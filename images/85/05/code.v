module top_module(
    // ports
    output wire out,
    input wire in1,
    input wire in2,
    input wire en
);// internal signals
    wire mux_output;

    // 2-to-1 multiplexer
    assign mux_output = (en == 1'b0) ? in1 : in2;

    // output
    assign out = mux_output;

endmodule