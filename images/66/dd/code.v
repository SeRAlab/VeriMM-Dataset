module top_module(addr, cs, re, we, clk, reset, data_in, data_out);parameter addr_width = 16; 
parameter data_width = 32; 
input [addr_width - 1 : 0] addr;
input cs; 
input re, we;
input clk,reset;
input [data_width - 1 : 0] data_in;
output [data_width - 1 : 0] data_out;
reg [data_width - 1 : 0] data_out;
reg [data_width - 1 : 0] mem [0 : 2 ** addr_width]; 
integer i;
always@(posedge clk)
begin: MEM
if(reset) begin
    mem[addr] <= 0;
end else begin
if(cs) begin
    if(we)	begin
        mem[addr] <= data_in; 
    end
    if(re) begin
        data_out <= mem[addr]; 
    end
end
end
end
endmodule