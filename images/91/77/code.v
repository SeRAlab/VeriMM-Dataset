module top_module(
input clock,
input rw,
input [15:0] add_bus,
inout [7:0] data_bus
);reg [7:0] cod_mem [8191:0];              

assign data_bus=(rw== 1'b1)?cod_mem[add_bus]:'bz; 
always@(posedge clock)
if(rw==1'b0)
cod_mem[add_bus] <= data_bus;
endmodule