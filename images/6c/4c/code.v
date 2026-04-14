module top_module(
    output [31:0] ResultW,
    output [4:0] WriteRegW2,
    output RegWriteW2,
    input [31:0] ReadDataW, ALUResultW,
    input [4:0] WriteRegW1,
    input MemToRegW, RegWriteW1
    );assign ResultW = MemToRegW ? ReadDataW : ALUResultW;

    
    assign WriteRegW2 = WriteRegW1;
    assign RegWriteW2 = RegWriteW1;

endmodule