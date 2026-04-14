module register_32bit#(
	parameter width = 32
)(
	input 					clk 	,   
	input 					rst		,
	input                   en      ,
	input	[width-1:0]		d		,
 
 	output	reg	[width-1:0]	q		
);

always @(posedge clk) begin
    if(rst) 
        q <= {width{1'b0}};
    else if(en) 
        q <= d;
end

endmodule