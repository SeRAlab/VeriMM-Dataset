module avr_io_out
 (	input clk,
	input rst,
	input io_re,
	input io_we,
	output [7:0] io_do,
	input [7:0] io_di,
	output [7:0] port
 );
reg [7:0] PORT;
assign port[7:0] = PORT[7:0]; 
assign io_do = io_re ? PORT : 8'b00000000;
always @(posedge clk) begin
	if (io_we) begin
		PORT <= io_di;
	end
end
endmodule