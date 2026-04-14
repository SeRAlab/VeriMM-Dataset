module top_module(
    input [255:0] in, // 256-bit input vector for the multiplexer
    input [7:0] sel, // 8-bit select input for the multiplexer
    input [49:0] in_maj, // 50-bit input vector for the majority gate
    output out // 1-bit output from the functional module
);// 256-to-1 multiplexer
    wire [255:0] mux_out;
    assign mux_out = in[sel];

    // 50-input majority gate
    wire maj_out;
    assign maj_out = (in_maj > 25);

    // Functional module
    assign out = (mux_out | maj_out);

endmodule