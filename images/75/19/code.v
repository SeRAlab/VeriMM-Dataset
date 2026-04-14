module top_module(

	rdaddr, 
	wraddr, 

	datain,  
	dataout, 

	we, 

	clk
);input [8:0] rdaddr;
	input [8:0] wraddr;

	input      [7:0] datain;
	output reg [7:0] dataout;

	input we;

	input clk;


	reg [7:0] mem[0:511]; 



	always @(posedge clk)
	begin
		dataout <= mem[rdaddr]; 

		if( we ) 
		begin
			mem[wraddr] <= datain;
		end
	end


endmodule