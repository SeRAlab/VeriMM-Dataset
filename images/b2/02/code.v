module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    input [7:0] in,
    output [7:0] out
);// 2-to-1 multiplexer
    wire mux_out;
    assign mux_out = (sel_b1 & sel_b2) ? b : a;

    // Bitwise AND module
    wire [7:0] and_out;
    assign and_out = in & 8'b11100011;

    // Functional module
    assign out = (mux_out == a) ? in : and_out;

endmodule