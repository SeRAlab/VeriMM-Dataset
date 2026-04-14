module top_module(
    // Inputs
    input [1:0] sel,
    input data0,
    input data1,
    input data2,
    input data3,
    // Outputs
    output out
);// Wires
    wire mux_out0;
    wire mux_out1;

    // Multiplexer
    assign mux_out0 = (sel == 2'b00) ? data0 : data1;
    assign mux_out1 = (sel == 2'b01) ? data2 : data3;
    assign out = (sel == 2'b10) ? mux_out0 : mux_out1;

endmodule