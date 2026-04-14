module top_module(
    input clk,
    input RegWrite,
    input [4:0] readReg1,
    input [4:0] readReg2,
    input [31:0] writeData,
    output reg [31:0] readData1,
    output reg [31:0] readData2
);reg [31:0] regfile[0:31];

always @(posedge clk) begin
    if (RegWrite) begin
        regfile[readReg1] <= writeData;
    end
end

assign readData1 = regfile[readReg1];
assign readData2 = regfile[readReg2];

endmodule