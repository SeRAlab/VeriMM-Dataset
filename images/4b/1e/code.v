module top_module(
        v_read,
        last,
        ap_return_0,
        ap_return_1
);parameter    ap_true = 1'b1;
parameter    ap_const_logic_1 = 1'b1;
parameter    ap_const_logic_0 = 1'b0;

input  [31:0] v_read;
input  [0:0] last;
output  [31:0] ap_return_0;
output  [0:0] ap_return_1;

wire   [31:0] e_data_V_fu_23_p1;



assign ap_return_0 = e_data_V_fu_23_p1;
assign ap_return_1 = last;
assign e_data_V_fu_23_p1 = v_read;


endmodule