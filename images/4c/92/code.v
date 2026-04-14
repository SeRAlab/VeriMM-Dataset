module top_module(
    input [7:0] a,
    input [7:0] b,
    input sel_b1,
    input sel_b2,
    input [3:0] c,
    output [7:0] out
);wire [7:0] selected_input;
assign selected_input = (sel_b1 & sel_b2) ? b : a;

assign out = selected_input & c;

endmodule