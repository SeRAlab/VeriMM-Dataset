module top_module(
    input wrEnable,
    input [4:0] wrReg,
    input [31:0] wrData,
    input [4:0] rdReg1,
    output reg [31:0] rdData1,
    input [4:0] rdReg2,
    output reg [31:0] rdData2,
    input clk
);reg [31:0] registers [0:31];

    always @(posedge clk) begin
        if (wrEnable) begin
            registers[wrReg] <= wrData;
        end
        rdData1 <= registers[rdReg1];
        rdData2 <= registers[rdReg2];
    end

endmodule