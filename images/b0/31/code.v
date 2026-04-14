module top_module(clk, Address, WriteData, MemWrite, MemRead, ReadData);input clk, MemWrite, MemRead;
    input [31:0]Address, WriteData;
    output [31:0]ReadData;

    
    reg [31:0]Memory [0:31];
    reg [31:0]ReadData;

    
    always @ (posedge clk)  begin
        if (MemWrite == 1'b1)   Memory[Address>>2] <= WriteData;
    end

    
    always @ (*)  begin
        if (MemRead == 1'b1)    ReadData <= Memory[Address>>2];
    end
endmodule