module reg_state (
    clk,in,rk,rt_out_s,
    ctrl_s,ctrl_rt_s,done,
    out_c,rt_in_s
);
    input           clk;
    input           in;
    input           rk;
    input           rt_out_s;
    input           ctrl_s;
    input           ctrl_rt_s;
    input           done;

    output          out_c;
    output          rt_in_s;


    reg    [31:0]   r0_p,r1_p,r2_p,r3_p;
    wire   [2:0]    ctrl_s;
    wire            temp;
    wire            done;  

    assign temp = r0_p[23] ^ r1_p[23] ^ r2_p[23] ^ rk;
    assign rt_in_s = (ctrl_rt_s) ? temp ^ rt_out_s : temp;
    assign out_c = (done) ? r0_p[31] : 0 ;

    always @(posedge clk) begin

        r0_p[31: 1] <= r0_p[30: 0];

            r1_p[31: 1] <= r1_p[30: 0];

            r2_p[31:25] <= r2_p[30:24];
            r2_p[23:19] <= r2_p[22:18];
            r2_p[17:11] <= r2_p[16:10];
            r2_p[ 9: 3] <= r2_p[ 8: 2];
            r2_p[1] <= r2_p[0];

            r3_p[31:25] <= r3_p[30:24];
            r3_p[23:19] <= r3_p[22:18];
            r3_p[17:11] <= r3_p[16:10];
            r3_p[ 9: 3] <= r3_p[ 8: 2];
            r3_p[1] <= r3_p[0];

            //0-1
            if (ctrl_s == 1) begin  
                r0_p[ 0] <= r1_p[31];

                r1_p[ 0] <= r2_p[31];

                r2_p[24] <= r2_p[23];
                r2_p[18] <= r2_p[17];
                r2_p[10] <= r2_p[ 9];
                r2_p[ 2] <= r2_p[ 1];
                r2_p[ 0] <= r3_p[31] ^ rt_out_s;

                r3_p[24] <= r3_p[23] ^ rt_out_s;
                r3_p[18] <= r3_p[17] ^ rt_out_s;
                r3_p[10] <= r3_p[ 9] ^ rt_out_s;
                r3_p[ 2] <= r3_p[ 1] ^ rt_out_s;
                r3_p[ 0] <= r0_p[31];
            end
            //2-9
            else if (ctrl_s == 3) begin
                r0_p[ 0] <= r1_p[31];

                r1_p[ 0] <= r2_p[31];

                r2_p[24] <= r2_p[23];
                r2_p[18] <= r2_p[17];
                r2_p[10] <= r2_p[ 9];
                r2_p[ 2] <= r2_p[ 1] ^ rt_out_s;
                r2_p[ 0] <= r3_p[31] ^ rt_out_s;

                r3_p[24] <= r3_p[23] ^ rt_out_s;
                r3_p[18] <= r3_p[17] ^ rt_out_s;
                r3_p[10] <= r3_p[ 9] ^ rt_out_s;
                r3_p[ 2] <= r3_p[ 1];
                r3_p[ 0] <= r0_p[31];
            end
            //10-17
            else if (ctrl_s == 2) begin
                r0_p[ 0] <= r1_p[31];

                r1_p[ 0] <= r2_p[31];

                r2_p[24] <= r2_p[23];
                r2_p[18] <= r2_p[17];
                r2_p[10] <= r2_p[ 9] ^ rt_out_s;
                r2_p[ 2] <= r2_p[ 1] ^ rt_out_s;
                r2_p[ 0] <= r3_p[31] ^ rt_out_s;

                r3_p[24] <= r3_p[23] ^ rt_out_s;
                r3_p[18] <= r3_p[17] ^ rt_out_s;
                r3_p[10] <= r3_p[ 9];
                r3_p[ 2] <= r3_p[ 1];
                r3_p[ 0] <= r0_p[31];
            end
            //18-23
            else if (ctrl_s == 6) begin
                r0_p[ 0] <= r1_p[31];

                r1_p[ 0] <= r2_p[31];

                r2_p[24] <= r2_p[23];
                r2_p[18] <= r2_p[17] ^ rt_out_s;
                r2_p[10] <= r2_p[ 9] ^ rt_out_s;
                r2_p[ 2] <= r2_p[ 1] ^ rt_out_s;
                r2_p[ 0] <= r3_p[31] ^ rt_out_s;

                r3_p[24] <= r3_p[23] ^ rt_out_s;
                r3_p[18] <= r3_p[17];
                r3_p[10] <= r3_p[ 9];
                r3_p[ 2] <= r3_p[ 1];
                r3_p[ 0] <= r0_p[31];
            end
            //24-31
            else if (ctrl_s == 7) begin
                r0_p[ 0] <= r1_p[31];

                r1_p[ 0] <= r2_p[31];

                r2_p[24] <= r2_p[23] ^ rt_out_s;
                r2_p[18] <= r2_p[17] ^ rt_out_s;
                r2_p[10] <= r2_p[ 9] ^ rt_out_s;
                r2_p[ 2] <= r2_p[ 1] ^ rt_out_s;
                r2_p[ 0] <= r3_p[31] ^ rt_out_s;

                r3_p[24] <= r3_p[23];
                r3_p[18] <= r3_p[17];
                r3_p[10] <= r3_p[ 9];
                r3_p[ 2] <= r3_p[ 1];
                r3_p[ 0] <= r0_p[31];
            end
            //inv
            else if (ctrl_s == 5) begin
                r0_p[ 0] <= r2_p[31];

                r1_p[ 0] <= r1_p[31];

                r2_p[24] <= r2_p[23];
                r2_p[18] <= r2_p[17];
                r2_p[10] <= r2_p[ 9];
                r2_p[ 2] <= r2_p[ 1];
                r2_p[ 0] <= r0_p[31];

                r3_p[24] <= r3_p[23];
                r3_p[18] <= r3_p[17];
                r3_p[10] <= r3_p[ 9];
                r3_p[ 2] <= r3_p[ 1];
                r3_p[ 0] <= r3_p[31];                
            end
            //done
            else if (ctrl_s == 4) begin
                r0_p[ 0] <= r1_p[31];

                r1_p[ 0] <= r2_p[31];

                r2_p[24] <= r2_p[23];
                r2_p[18] <= r2_p[17];
                r2_p[10] <= r2_p[ 9];
                r2_p[ 2] <= r2_p[ 1];
                r2_p[ 0] <= r3_p[31];

                r3_p[24] <= r3_p[23];
                r3_p[18] <= r3_p[17];
                r3_p[10] <= r3_p[ 9];
                r3_p[ 2] <= r3_p[ 1];
                r3_p[ 0] <= r0_p[31];
            end
            //round == 0
            else begin
                r0_p[ 0] <= r1_p[31];

                r1_p[ 0] <= r2_p[31];

                r2_p[24] <= r2_p[23];
                r2_p[18] <= r2_p[17];
                r2_p[10] <= r2_p[ 9];
                r2_p[ 2] <= r2_p[ 1];
                r2_p[ 0] <= r3_p[31];

                r3_p[24] <= r3_p[23];
                r3_p[18] <= r3_p[17];
                r3_p[10] <= r3_p[ 9];
                r3_p[ 2] <= r3_p[ 1];
                r3_p[ 0] <= in;
            end
    end

endmodule