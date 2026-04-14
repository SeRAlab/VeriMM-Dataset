module top_module(
	input	[31:0]	fp_in,         
	output reg [31:0] int_out      
	);wire    [7:0]   bias_exp;       
wire    [7:0]   bias_exp2;      
wire    [39:0]  fixed_out2;     
wire    [47:0]  bias_mant;      
reg     [38:0]  int_fixed_out;

reg    [31:0]  fixed_out;

assign bias_mant = {25'h0001, fp_in[22:0]};
assign bias_exp = fp_in[30:23] - 'd127;
assign bias_exp2 = ~bias_exp + 1;


always @* begin
	
  	if (fp_in[30:0] == 31'b0) int_fixed_out = 0;
  	
	else if (bias_exp[7]) int_fixed_out = bias_mant >> bias_exp2;
  	
	else int_fixed_out = bias_mant << bias_exp;

	fixed_out = int_fixed_out[38:7] + int_fixed_out[6];
	int_out = (fp_in[31]) ? ~fixed_out + 1 : fixed_out;
end

endmodule