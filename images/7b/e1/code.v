module top_module(
	//Inputs
	clock,
	reset,
	enable,
	
   i_x, 
   i_y, 
   i_z, 

	//Outputs
	o_x,
	o_y,
	o_z
	);//////////////////////////////////////////////////////////////////////////////
//PARAMETERS
//////////////////////////////////////////////////////////////////////////////
parameter BIT_WIDTH=32;

input				clock;
input				reset;
input				enable;

input	[BIT_WIDTH-1:0]			i_x;
input	i_y;
input	i_z;


output	[BIT_WIDTH-1:0]			o_x;
output	o_y;
output	o_z;

wire				clock;
wire				reset;
wire				enable;

wire	[BIT_WIDTH-1:0]			i_x;
wire	i_y;
wire	i_z;

reg	[BIT_WIDTH-1:0]			o_x;
reg	o_y;
reg	o_z;

always @ (posedge clock)
	if(reset) begin
		o_x		<=	{BIT_WIDTH{1'b0}} ;
		o_y		<=	1'b0;
		o_z		<=	1'b0;
	end else if(enable) begin
		o_x		<=	i_x;
		o_y		<=	i_y;
		o_z		<=	i_z;
	end
endmodule