module mux_2to1_8bit#(
	parameter width = 8
)(
	input 					sel 	,   
	input	[width-1:0]		in0		,
	input	[width-1:0]		in1		,
 
 	output	reg	[width-1:0]	out	
);

always @(*) begin
    if(sel) 
        out = in1;
    else 
        out = in0;
end

endmodule