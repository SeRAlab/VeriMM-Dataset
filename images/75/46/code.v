module top_module(
	dataa,
	datab,
	signa,
	signb,
	addsub,
	sum,
	sumsign
);parameter width_a = 1;
	parameter width_b = 1;
	parameter adder_mode = "use_port"; 
	parameter dataa_signed = "use_port"; 
	parameter datab_signed = "use_port"; 

	localparam width_sum = ( width_a >= width_b ) ? ( width_a + 1 ) :
		( width_b + 1 );

	input [ width_a - 1 : 0 ] dataa;
	input [ width_b - 1 : 0 ] datab;

	input signa;
	input signb;
	input addsub;

	output [ width_sum - 1 : 0 ] sum;
	output sumsign;

	wire [ width_sum - 1 : 0 ] sum;
	wire signed sumsign;

	wire signed [ width_a : 0 ] signed_a;
	wire signed [ width_b : 0 ] signed_b;
	wire signed [ width_sum : 0 ] signed_sum;

	generate 
		if( dataa_signed == "use_port" ) begin
			assign signed_a = {((signa==1'b1) ? dataa[width_a-1]: 1'b0) ,dataa };
		end
		else if( dataa_signed == "true" ) begin
			assign signed_a = { dataa[width_a-1], dataa };
		end
		else if( dataa_signed == "false" ) begin
			assign signed_a = { 1'b0, dataa };
		end

		if( datab_signed == "use_port" ) begin
			assign signed_b = {((signb==1'b1) ? datab[width_b-1]: 1'b0) ,datab };
		end
		else if( datab_signed == "true" ) begin
			assign signed_b = { datab[width_b-1], datab };
		end
		else if( datab_signed == "false" ) begin
			assign signed_b = { 1'b0, datab };
		end

		if( adder_mode == "use_port" ) begin
			assign signed_sum = addsub ? signed_a + signed_b :
				signed_a - signed_b;
		end
		else if( adder_mode == "add" ) begin
			assign signed_sum = signed_a + signed_b; 
		end
		else if ( adder_mode == "sub" ) begin
			assign signed_sum = signed_a - signed_b;
		end
	endgenerate

	assign sum = signed_sum[ width_sum - 1 : 0 ];
	assign sumsign = signed_sum[ width_sum ];

endmodule