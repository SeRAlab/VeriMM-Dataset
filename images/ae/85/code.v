module alu_16bit#(
	parameter width = 16
)(
	input	[width-1:0]		a			,
	input	[width-1:0]		b			,
	input 					ctrl		,
 
 	output	reg	[width-1:0]	result		,
    output  reg             carry_out
);

always @(*) begin
    if(ctrl == 1'b0) begin
        {carry_out, result} = a + b;
    end else begin
        {carry_out, result} = a - b;
    end
end

endmodule