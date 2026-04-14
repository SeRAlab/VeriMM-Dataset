module top_module(
    input clock,
    input reset,
    input debugEnable,
    input debugReset,
    input [4:0] writeRegister,
    input [31:0] aluOut,
    input [31:0] memoryOut,
    input regWrite,
    input memToReg,
    input eop,
    
    output reg [4:0] writeRegisterOut,
    output reg [31:0] aluOutOut,
    output reg [31:0] memoryOutOut,
    output reg regWriteOut,
    output reg memToRegOut,
    output reg eopOut
);reg [4:0] writeRegisterReg;
    reg [31:0] aluOutReg;
    reg [31:0] memoryOutReg;
    reg regWriteReg;
    reg memToRegReg;
    reg eopReg;

    always @(posedge clock) begin
        if (reset) begin
            writeRegisterReg <= 0;
            aluOutReg <= 0;
            memoryOutReg <= 0;
            regWriteReg <= 0;
            memToRegReg <= 0;
            eopReg <= 0;
        end
        else if (debugReset) begin
            writeRegisterReg <= 0;
            aluOutReg <= 0;
            memoryOutReg <= 0;
            regWriteReg <= 0;
            memToRegReg <= 0;
            eopReg <= 0;
        end
        else begin
            writeRegisterReg <= writeRegister;
            aluOutReg <= aluOut;
            memoryOutReg <= memoryOut;
            regWriteReg <= regWrite;
            memToRegReg <= memToReg;
            eopReg <= eop;
        end
    end

    assign writeRegisterOut = writeRegisterReg;
    assign aluOutOut = aluOutReg;
    assign memoryOutOut = memoryOutReg;
    assign regWriteOut = regWriteReg;
    assign memToRegOut = memToRegReg;
    assign eopOut = eopReg;

endmodule