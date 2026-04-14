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
);parameter BIT_WIDTH = 32;

input clock;
input reset;
input enable;

input [BIT_WIDTH-1:0] i_x;
input [BIT_WIDTH-1:0] i_y;
input [BIT_WIDTH-1:0] i_z;

output [BIT_WIDTH-1:0] o_x;
output [BIT_WIDTH-1:0] o_y;
output [BIT_WIDTH-1:0] o_z;

wire clock;
wire reset;
wire enable;

wire [BIT_WIDTH-1:0] i_x;
wire [BIT_WIDTH-1:0] i_y;
wire [BIT_WIDTH-1:0] i_z;

reg [BIT_WIDTH-1:0] o_x;
reg [BIT_WIDTH-1:0] o_y;
reg [BIT_WIDTH-1:0] o_z;

always @(posedge clock) begin
	if (reset) begin
		o_x <= {BIT_WIDTH{1'b0}};
		o_y <= {BIT_WIDTH{1'b0}};
		o_z <= {BIT_WIDTH{1'b0}};
	end else if (enable) begin
		o_x <= i_x;
		o_y <= i_y;
		o_z <= i_z;
	end
end

endmodule