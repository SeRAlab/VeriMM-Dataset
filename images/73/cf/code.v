module top_module(
    clk,
    reset,
	data_in,
	data_out
);parameter noc_dw = 32; 
parameter byte_dw = 8; 


input wire clk;
input wire reset;

input wire [noc_dw - 1:0] data_in; 
output reg [noc_dw  - 1:0] data_out;


always@(posedge clk) begin
	if(reset)
		data_out <= 32'd0;
	else
		data_out <= data_in;
end 

endmodule