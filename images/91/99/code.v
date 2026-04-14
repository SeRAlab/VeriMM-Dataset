module top_module(
    input wire in1,
    input wire in2,
    input wire in3,
    output wire out1
);wire Net_9;
    wire Net_8;
    wire Net_7;

    // Replace the unknown module SCB_P4_v1_20_0 with a valid module or comment it out.
    // Uncomment the code below if the module is available in your environment.

    // SCB_P4_v1_20_0 I2C_1 (
    //     .sclk(Net_7),
    //     .interrupt(Net_8),
    //     .clock(1'b0)
    // );

    assign Net_7 = in1;
    assign Net_8 = in2;
    assign out1 = Net_8;

endmodule