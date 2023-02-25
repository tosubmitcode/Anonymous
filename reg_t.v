module reg_t (
    clk,in,sbox_out,ctrl_sbox,sbox_in,out
);
    input           clk;
    input           in;
    input   [7:0]   sbox_out;
    input           ctrl_sbox;              
    output          out;
    output  [7:0]   sbox_in;

    reg     [7:0]  temp_p;         
     
    assign sbox_in = {temp_p[6:0],in};
    assign out = temp_p[7]; 

    always @(posedge clk) begin         
        if (ctrl_sbox) 
            temp_p [7:0] <= sbox_out;   
        else  temp_p[7:0] <= {temp_p[6:0],in};  
    end
endmodule
