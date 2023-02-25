module reg_t_k (
    clk,in,sbox_out,ctrl_sbox,sbox_in,out
);
    input           clk;

    input           in;
    input   [7:0]   sbox_out;
    input           ctrl_sbox;              
    output          out;
    output  [7:0]   sbox_in;

    reg     [7:0]  temp_p;         
     
    assign  sbox_in = temp_p[7:0];
    assign out = (ctrl_sbox) ? sbox_out[7] : temp_p[7]; 

    always @(posedge clk) begin         
        if (ctrl_sbox) begin
            temp_p [7:0] <= {sbox_out[6:0],in};  
        end  
        else  begin
            temp_p[7:0] <= {temp_p[6:0],in};
        end
    end
endmodule