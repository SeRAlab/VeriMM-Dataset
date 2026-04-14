module top_module(
    O,     // output
    I,     // input
    IBUFDISABLE  // input
);parameter IBUF_LOW_PWR = "TRUE";
    parameter IOSTANDARD = "DEFAULT";
    parameter SIM_DEVICE = "7SERIES";
    parameter USE_IBUFDISABLE = "TRUE";

    output O;
    input I;
    input IBUFDISABLE;

    wire out_val;

    assign out_val = (SIM_DEVICE == "7SERIES") ? 1'b1 : 1'b0;

    assign O = (USE_IBUFDISABLE == "TRUE") ? ((IBUFDISABLE == 1'b0) ? I : ((IBUFDISABLE == 1'b1) ? out_val : 1'bx)) : I;

endmodule