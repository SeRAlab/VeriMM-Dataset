module top_module(Address, Write_data, Read_data, MemRead, MemWrite, clk);input [31:0] Address, Write_data;
    input MemRead, MemWrite, clk;
    output reg [31:0] Read_data;
    reg [31:0] mem[31:0];

    always @ (posedge clk)
    begin
        if (MemWrite) mem[Address >> 2] = Write_data; 
    end

    always @ (negedge clk)
    begin
        if (MemRead) Read_data = mem[Address >> 2];
    end

endmodule