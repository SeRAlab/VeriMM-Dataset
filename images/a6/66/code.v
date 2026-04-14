module top_module(
	input		[2:0]	in, 
	input		[2:0]	sum,
	output	reg [2:0]	out	
);reg	[3:0] aux;

always @(*) begin
	aux <= in+sum;
	case( aux )
		4'd6:	out <= 3'd0;
		4'd7:	out <= 3'd1;
		4'd8:	out <= 3'd2;
		4'd9:	out <= 3'd3;
		4'ha:	out <= 3'd4;
		4'hb:	out <= 3'd5;
		4'hc:	out <= 3'd0;
		4'he:	out <= 3'd1;
		4'hf:	out <= 3'd2;
		default:	out <= aux;
	endcase
end

endmodule