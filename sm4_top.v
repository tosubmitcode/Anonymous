module sm4_top (
    clk,rst,start,i_plaintext,i_key,
    o_data,o_done
);
    input           clk;
    input           rst;
    input           start;
    input           i_plaintext;
    input           i_key;

    output          o_data;
    output          o_done;

    wire            fk;
    wire            ck;
    wire            rk;
    wire            rt_out_k;
    wire            rt_in_k;
    wire    [1:0]   ctrl_k;
    wire    [2:0]   ctrl_s;
    wire            ctrl_rt_s;
    wire            rt_out_s;
    wire            rt_in_s;
    wire            ctrl_sbox;
    wire            ctrl_sbox_k;
    wire    [7:0]   sbox_in;
    wire    [7:0]   sbox_in_k;  
    wire    [7:0]   sbox_out;
    wire    [7:0]   sbox_in_s;
    wire            ctrl_ck;
    wire    [7:0]   d_ck;

    assign sbox_in = (ctrl_sbox_k) ? sbox_in_k : sbox_in_s; 

    control c(
        .clk(clk),
        .rst(rst),
        .start(start),
        .d_ck(d_ck),
        .ctrl_k(ctrl_k),
        .ctrl_s(ctrl_s),
        .ctrl_rt_s(ctrl_rt_s),
        .ctrl_sbox(ctrl_sbox),
        .ctrl_sbox_k(ctrl_sbox_k),
        .ctrl_ck(ctrl_ck),
        .ctrl_init_ck(ctrl_init_ck),
        .done(o_done),
        .ck(ck),
        .fk(fk)
    );

    reg_key key(
    .clk(clk),
    .in(i_key),
    .fk(fk),
    .ck(ck),
    .rt_out_k(rt_out_k),
    .ctrl_k(ctrl_k),
    .out_rk(rk),
    .rt_in_k(rt_in_k)
    );

    reg_state state(
    .clk(clk),
    .in(i_plaintext),
    .rk(rk),
    .rt_out_s(rt_out_s),
    .ctrl_s(ctrl_s),
    .ctrl_rt_s(ctrl_rt_s),
    .done(o_done),
    .out_c(o_data),
    .rt_in_s(rt_in_s)
    );

    reg_t_k t_key(
    .clk(clk),
    .in(rt_in_k),
    .sbox_out(sbox_out),
    .ctrl_sbox(ctrl_sbox_k),
    .sbox_in(sbox_in_k),
    .out(rt_out_k)
    );

    reg_t t_state(
    .clk(clk),
    .in(rt_in_s),
    .sbox_out(sbox_out),
    .ctrl_sbox(ctrl_sbox),
    .sbox_in(sbox_in_s),
    .out(rt_out_s)
    );

    ck ck0(
    .clk(ctrl_ck),
    .init(ctrl_init_ck),
    .out(d_ck)
    );
    
    sbox s(
    .b(sbox_in),
    .Sb(sbox_out)
    );
endmodule