module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [3:0] a, // 4-bit input A
    input [3:0] b, // 4-bit input B
    input sel, // Select input to choose between addition and multiplexer
    output [3:0] q // 4-bit output from the module
);// Create a 2:1 multiplexer with two additional inputs set to 0 and 1
    wire [3:0] mux_out;
    wire inv_mux_out;
    assign mux_out = sel ? {4{1'b0}} : a;
    assign inv_mux_out = (b >= mux_out) ? ~mux_out : mux_out;

    // Create an adder with carry-in and carry-out ports
    wire [3:0] add_out;
    wire carry_out;
    assign {carry_out, add_out} = a + b;

    // Choose between the output of the adder and the multiplexer
    assign q = sel ? inv_mux_out : add_out;

endmodule