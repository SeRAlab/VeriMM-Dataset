module counter_updown_64bit#(
	parameter width = 64
)(
	input 					clk 		,   
	input 					rst			,
	input                   up_down     ,
 
 	output	reg	[width-1:0]	count		
);

always @(posedge clk) begin
    if(rst) 
        count <= {width{1'b0}};
    else if(up_down) 
        count <= count + 1;
    else 
        count <= count - 1;
end

endmodule