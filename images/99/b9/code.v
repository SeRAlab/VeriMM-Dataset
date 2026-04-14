module top_module(
    input wire [15:0] inputData,
    output wire [3:0] outputData
);assign outputData = inputData[15:12];

endmodule