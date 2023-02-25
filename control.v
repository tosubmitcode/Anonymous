module control (
    clk,rst,start,d_ck,
    ctrl_k,ctrl_s,ctrl_rt_s,ctrl_sbox,ctrl_sbox_k,ctrl_ck,ctrl_init_ck,
    done,ck,fk
);

    input           clk;
    input           rst;
    input           start;
    input           d_ck;

    output          ctrl_k;
    output          ctrl_s;
    output          ctrl_rt_s;
    output          ctrl_sbox;
    output          ctrl_sbox_k;
    output          ctrl_ck;
    output          ctrl_init_ck;

    output          done;
    output          ck;
    output          fk;

    localparam [0:127] d_fk = {32'ha3b1bac6,32'h56aa3350,32'h677d9197,32'hb27022dc};


    reg     [5:0]   round;   
    reg     [6:0]   count; 
    reg     [1:0]   ctrl_k;
    reg     [2:0]   ctrl_s;
    reg             ctrl_rt_s;
    reg             ctrl_sbox;
    reg             ctrl_sbox_k;
    reg             ctrl_ck;
    reg             ck;
    reg             ctrl_init_ck;
    reg             done;

    wire    [7:0]   d_ck;
    wire            fk;

    assign fk = d_fk[count];

    //round、count
    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            count   <= 0;
            round   <= 0;
        end
        else begin  
            if (start == 0 ) begin
                count   <= 0;
                round   <= 0;
            end    
            else begin   
                if (round == 0 && count == 7'b1111111) begin   
                    round <= round + 6'b000001;
                    count <= 6'b000000;
                end 
                if (round == 35 && count == 7'b1111111) begin   
                    round <= 0;
                    count <= 6'b000000;
                end 
                else if (round != 0 && round != 35 && count == 7'b0011111) begin
                    round <= round + 6'b000001;
                    count <= 6'b000000;
                end
                else    count <= count +  7'b0000001; 
            end
        end
    end

    //ctrl_k
    always @(*) begin
        if (round != 0 && 0 <= count && count <= 12) begin
            ctrl_k = 2'b01;
        end
        else if (round != 0 && 13 <= count && count <= 22) begin
            ctrl_k = 2'b11;
        end
        else if (round != 0 && 23 <= count && count <= 31) begin
            ctrl_k = 2'b10;
        end
        else ctrl_k = 2'b00;
    end

    //ctrl_s
    always @(*) begin
        if ( 2 <= round && round <= 33 && 0 <= count && count <= 1) begin
            ctrl_s = 3'b001;
        end
        else if ( 2 <= round && round <= 33 && 2 <= count && count <= 9) begin
            ctrl_s = 3'b011;
        end
        else if ( 2 <= round && round <= 33 && 10 <= count && count <= 17) begin
            ctrl_s = 3'b010;
        end
        else if ( 2 <= round && round <= 33 && 18 <= count && count <= 23) begin
            ctrl_s = 3'b110;
        end
        else if ( 2 <= round && round <= 33 && 24 <= count && count <= 31) begin
            ctrl_s = 3'b111;
        end
        else if (round == 34) begin
            ctrl_s = 3'b101;
        end
        else if (round == 1 || (35 == round )) begin
            ctrl_s = 3'b100;
        end
        else ctrl_s = 3'b000;
    end

    always @(*) begin
        if (2 <= round && 24 <= count) begin
            ctrl_rt_s = 1;
        end
        else ctrl_rt_s = 0;
    end

    //ctrl_sbox
    always @(*) begin
        if (count == 127) begin
            ctrl_sbox = 1;
        end
        else if (round != 0 && count[2:0] == 7) begin
            ctrl_sbox = 1;
        end
        else ctrl_sbox = 0;
    end

    always @(*) begin
        if (round != 0 && count[2:0] == 0) begin    //1 <= round && round <= 32
            ctrl_sbox_k = 1;
        end
        else ctrl_sbox_k = 0;
    end    

    //ctrl_ck
    always @(*) begin
        if (count == 120) 
            ctrl_ck = 1;
        else if (round !=0 && count[2:0] == 0 ) 
            ctrl_ck = 1;
        else ctrl_ck = 0;
    end

    //ck
    always @(*) begin
        if (120 <= count && count <= 127) begin
            ck = d_ck[count[2:0]];
        end
        else if (round != 0) begin
            ck = d_ck[count[2:0]];
        end     
        else ck = 0;
    end

    //ctrl_init_ck
    always @(*) begin
        if (count == 120 ) 
            ctrl_init_ck = 1;
        else ctrl_init_ck = 0;
    end


    //done
    always @(*) begin
        if ( round == 35 ) begin
            done = 1;
        end
        else done = 0;
    end




endmodule