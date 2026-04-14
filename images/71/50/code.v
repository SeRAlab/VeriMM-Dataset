module top_module(
    input clk,
    input rst,
	 input [1:0]EN,
    input aumento,
    input disminuye,
    output reg [6:0] cont_year
	 
    );always @(posedge clk )
begin
	if (rst || cont_year==7'd99)
		cont_year<=7'b0;
	else  if (EN==2'd2) begin
		
		if (aumento) begin
			cont_year<=cont_year + 7'b1;
			 end
		else if (disminuye) begin
			if (cont_year==7'd0) cont_year<=0;
			else begin
				cont_year<=cont_year - 7'b1;
				 end end
		else begin
			cont_year <= cont_year;	
			
			end
	end
end
endmodule