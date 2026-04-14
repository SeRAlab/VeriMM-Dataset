module top_module(
    input clock_in,
    input [25:21] readReg1,
    input [20:16] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    input regWrite,
    input rst,
    input [31:0] PC,
    input [1:0] switch,
    output reg [31:0] readData1,
    output reg [31:0] readData2,
    output reg [7:0] led
);reg [31:0] regFile [0:31]; // 32 registers

integer i;

initial begin
    for (i = 0; i < 32; i = i + 1) begin
        regFile[i] = i;
    end
end

always @ (readReg1 or readReg2 or regWrite or writeReg or switch) begin
    readData1 = regFile[readReg1];
    readData2 = regFile[readReg2];

    case(switch)
        2'd0: led = PC[7:0];
        2'd1: led = regFile[1][7:0];
        2'd2: led = regFile[2][7:0];
        2'd3: led = regFile[3][7:0];
    endcase
end

always @ (negedge clock_in) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            regFile[i] = 0;
        end
    end else if (regWrite) begin
        regFile[writeReg] = writeData;
    end
end

endmodule