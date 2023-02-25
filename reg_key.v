module reg_key (
    clk,in,fk,ck,rt_out_k,
    ctrl_k,
    out_rk,rt_in_k
);
    input           clk;
    input           in;
    input           fk;
    input           ck;
    input           rt_out_k;
    input           ctrl_k;

    output          out_rk;
    output          rt_in_k;


    reg    [31:0]   r0_p,r1_p,r2_p,r3_p;
    wire   [1:0]    ctrl_k;


    assign rt_in_k = r1_p[23] ^ r2_p[23] ^ r3_p[23] ^ ck;
    assign out_rk = r3_p[23];

    always @(posedge clk) begin

        r0_p[31:24] <= r0_p[30:23];
        r0_p[22:14] <= r0_p[21:13];
        r0_p[12:0] <= {r0_p[11:0],r1_p[31]};

        r1_p <= {r1_p[30:0],r2_p[31]};
        r2_p <= {r2_p[30:0],r3_p[31]};

        r3_p[31:24] <= r3_p[30:23];
        r3_p[22:14] <= r3_p[21:13];
        r3_p[12:1] <= r3_p[11:0];

        //0-12
        if (ctrl_k == 1) begin             
            r0_p[23] <= r0_p[22] ^ rt_out_k;
            r0_p[13] <= r0_p[12] ^ rt_out_k;

            r3_p[23] <= r3_p[22];
            r3_p[13] <= r3_p[12];
            r3_p[0] <= r0_p[31] ^ rt_out_k;
        end
        //13-22
        else if (ctrl_k == 3) begin
            r0_p[23] <= r0_p[22] ^ rt_out_k;
            r0_p[13] <= r0_p[12];
                    
            r3_p[23] <= r3_p[22];
            r3_p[13] <= r3_p[12] ^ rt_out_k;
            r3_p[0] <= r0_p[31] ^ rt_out_k;
        end
        //23-31
        else if (ctrl_k == 2) begin
            r0_p[23] <= r0_p[22];
            r0_p[13] <= r0_p[12];

            r3_p[23] <= r3_p[22] ^ rt_out_k;
            r3_p[13] <= r3_p[12] ^ rt_out_k;
            r3_p[0] <= r0_p[31] ^ rt_out_k;
        end
        //round == 0
        else begin
            r0_p[23] <= r0_p[22];
            r0_p[13] <= r0_p[12];

            r3_p[23] <= r3_p[22];
            r3_p[13] <= r3_p[12];
            r3_p[0] <= in ^ fk;
        end
    end

endmodule