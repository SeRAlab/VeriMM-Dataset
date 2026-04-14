module top_module(
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        a,
        b,
        ap_return
);input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [31:0] a;
input  [31:0] b;
output  [31:0] ap_return;

parameter    ap_const_logic_1 = 1'b1;
parameter    ap_const_logic_0 = 1'b0;



assign ap_done = ap_start;
assign ap_idle = ap_const_logic_1;
assign ap_ready = ap_start;
assign ap_return = (b + a);


endmodule