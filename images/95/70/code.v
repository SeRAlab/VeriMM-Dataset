module top_module(

	input  wire        clk,

	input  wire [10:0] wraddr,
	input  wire [ 7:0] wrdata,
	input  wire        wr_stb,

	input  wire [10:0] rdaddr,
	output reg  [ 7:0] rddata
);reg [7:0] mem [0:1535];

	always @(posedge clk)
	begin
		if( wr_stb )
		begin
			mem[wraddr] <= wrdata;
		end

		rddata <= mem[rdaddr];
	end

endmodule