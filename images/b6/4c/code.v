module top_module(
    input d,
    output reg q,
	 input r ,
    input clk
    );always @ (posedge clk) 

begin 
if (r == 1 ) 
	q <= 0 ; 
else 
	q <= d ; 

end 


endmodule