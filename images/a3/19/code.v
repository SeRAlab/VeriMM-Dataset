module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    input [15:0] c,
    output [15:0] out
);// 2-to-1 multiplexer
    wire [15:0] mux_out;
    assign mux_out = (sel_b1 == 0) ? a : ((sel_b1 == 1 && sel_b2 == 0) ? b : (a | b));

    // 16-bit adder
    wire [15:0] adder_out;
    assign adder_out = mux_out + c;

    // Functional module
    wire [15:0] func_out;
    assign func_out = (sel_b1 == 0) ? adder_out : (mux_out - c);

    // Final output
    assign out = func_out;

endmodule