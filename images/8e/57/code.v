module top_module( clock, dataa, datab, result);input clock;
	input [31:0] dataa;
	input [31:0] datab;
	output [63:0] result;
	reg [63:0] result;
	
	wire [63:0] prelim_result;
	
	
	wire [31:0] opa;
	wire [31:0] opb;
	wire [31:0] opa_comp;
	wire [31:0] opb_comp;
	
	assign opa_comp =  ((~dataa) + 32'b00000000000000000000000000000001);

	assign opb_comp =  ((~datab) + 32'b00000000000000000000000000000001);

	
	wire opa_is_neg;
	wire opb_is_neg;
	assign opa_is_neg = dataa[31];
	assign opb_is_neg = datab [31];
	assign opa = (opa_is_neg== 1'b1) ? opa_comp:dataa;
	assign opb = (opb_is_neg == 1'b1) ? opb_comp:datab;
	
	
	assign prelim_result = opa * opb ;
	wire sign;
	assign sign = dataa[31] ^ datab[31];
	
	wire [63:0] prelim_result_comp;
	wire [63:0] prelim_result_changed;
	wire [63:0] result_changed;
	assign result_changed = (sign==1'b1)? prelim_result_comp :prelim_result;
	assign prelim_result_comp =  ((~prelim_result) + 1);
	
	always @ (posedge clock)
	begin
	result <= result_changed;
	end
	
	endmodule