module top_module(
    input clk,
    input regWrite,
    input [4:0] readReg1,
    input [4:0] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    output reg [31:0] readData1, 
    output reg [31:0] readData2
    );reg [31:0] regFile [0:31]; // Adjusted array index to be [0:31]

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        regFile[i] = 0; // Non-blocking assignment changed to blocking
    end
end

always @(*) // Changed event sensitivity list
begin
    readData1 = regFile[readReg1]; // Non-blocking assignment changed to blocking
    readData2 = regFile[readReg2]; // Non-blocking assignment changed to blocking
end

always @(posedge clk) 
begin
    if (regWrite)
        regFile[writeReg] <= writeData;
end

endmodule