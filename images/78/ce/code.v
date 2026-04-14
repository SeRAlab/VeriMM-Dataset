module top_module(
    input clk, reset, regWrite,
    input [3:0] writeReg, readReg1, readReg2,
    input [31:0] writeData,
    output [31:0] readData1, readData2
);reg [31:0] registers [0:15];

integer i;  // Variable for initialization

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 16; i = i + 1) begin
            registers[i] <= 32'd0; // Initialize each register to 0
        end
    end else if (regWrite) begin
        registers[writeReg] <= writeData;
    end
end

assign readData1 = registers[readReg1];
assign readData2 = registers[readReg2];

endmodule