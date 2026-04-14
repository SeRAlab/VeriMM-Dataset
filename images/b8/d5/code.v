module top_module(
        ap_ready,
        a_V,
        w_V,
        ap_return
);output   ap_ready;
input  [5:0] a_V;
input  [6:0] w_V;
output  [15:0] ap_return;

wire  signed [5:0] mul_ln728_fu_32_p0;
wire  signed [6:0] mul_ln728_fu_32_p1;
wire   [10:0] mul_ln728_fu_32_p2;

assign ap_ready = 1'b1;

assign ap_return = {{mul_ln728_fu_32_p2}, {5'd0}};

assign mul_ln728_fu_32_p0 = a_V;

assign mul_ln728_fu_32_p1 = w_V;

assign mul_ln728_fu_32_p2 = ($signed(mul_ln728_fu_32_p0) * $signed(mul_ln728_fu_32_p1));

endmodule