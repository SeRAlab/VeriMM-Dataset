module top_module(
    input clock_in,
    input regWrite,
    input [4:0] readReg1,
    input [4:0] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    output reg [31:0] readData1,
    output reg [31:0] readData2
);reg [31:0] registers [0:31];

always @ (posedge clock_in) begin
    readData1 <= registers[readReg1];
    readData2 <= registers[readReg2];
    if (regWrite) begin
        registers[writeReg] <= writeData;
    end
end

endmodule