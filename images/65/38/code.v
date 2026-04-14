module top_module( 
	data,
	q
	) ;input   [31:0]  data;
	output   [4:0]  q;
	
	wire  [3:0]   wire_altpriority_encoder6_q;
	wire  [3:0]   wire_altpriority_encoder7_q;
	wire  wire_altpriority_encoder7_zero;

	assign wire_altpriority_encoder7_zero = (data[31:16] == 0);

	assign wire_altpriority_encoder6_q = 
		(data[15:0] == 0) ? 4'b0001 :
		(data[15:0] == 1) ? 4'b0010 :
		(data[15:0] == 2) ? 4'b0100 :
		(data[15:0] == 3) ? 4'b1000 :
		4'b0000;

	assign wire_altpriority_encoder7_q = 
		(data[31:16] == 0) ? 4'b0001 :
		(data[31:16] == 1) ? 4'b0010 :
		(data[31:16] == 2) ? 4'b0100 :
		(data[31:16] == 3) ? 4'b1000 :
		4'b0000;

	assign q = {(~wire_altpriority_encoder7_zero), 
		((wire_altpriority_encoder7_zero & wire_altpriority_encoder6_q) | (~wire_altpriority_encoder7_zero & wire_altpriority_encoder7_q))};
endmodule