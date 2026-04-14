module top_module(WriteData,   
            MemData,     
            Address,     
            MemWrite,   
            Clk);parameter ADDRESS_WIDTH = 16;
parameter DATA_WIDTH = 32;


input [DATA_WIDTH-1:0]       WriteData;
input [ADDRESS_WIDTH-1:0]    Address;
input MemWrite;
input Clk;

output [DATA_WIDTH-1:0] MemData;


reg [DATA_WIDTH-1:0] mem_contents [ADDRESS_WIDTH-1:0];
integer i;

assign MemData= mem_contents[Address];

always @(posedge Clk)
begin
	if(MemWrite)
	begin
		mem_contents[Address]<= #5 WriteData;
	end
end

endmodule