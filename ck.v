module ck (
    clk,init,out
);
    input               clk;   
    input               init;
    output  [7:0]       out;
    
    reg     [7:0]       temp;

    always @(posedge clk) begin
        if (init) 
            temp <= 8'b00000000;
        else temp <= temp + 8'b00000111;
    end

    assign out = {temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7]};
endmodule
