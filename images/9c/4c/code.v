module top_module(
    input [2:0] a,
    input [2:0] b,
    input sel_b1,
    input sel_b2,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);// Bitwise OR circuit
    wire [2:0] bitwise_or;
    assign bitwise_or = a | b;

    // Logical OR circuit
    wire logical_or;
    assign logical_or = (a[0] || a[1] || a[2]) || (b[0] || b[1] || b[2]);

    // Multiplexer
    wire [2:0] mux_out;
    assign mux_out = sel_b1 ? (sel_b2 ? bitwise_or | logical_or : logical_or) : bitwise_or;

    // Inverse outputs
    assign out_not = {~b, ~a};

    // Outputs
    assign out_or_bitwise = bitwise_or;
    assign out_or_logical = logical_or;

endmodule