module top_module(
	input wire clk,		
	input wire rst,		
	output wire logic_en, 
	output wire logic_en_1, 
	output wire pix_en,		
	output wire display_en 
	
	);reg [17:0] q;





always @(posedge clk)
begin
	
	if (rst == 1)
		q <= 0;
	
	else
		q <= q+1;
end





assign logic_en = q[15] & ~q[14] & ~q[13] & ~q[12] & ~q[11] & ~q[10] & ~q[9] & ~q[8] & ~q[7] & ~q[6] & ~q[5] & ~q[4] & ~q[3]& ~q[2] & ~q[1]& ~q[0];
assign logic_en_1 = q[15] & ~q[14] & ~q[13] & ~q[12] & ~q[11] & ~q[10] & ~q[9] & ~q[8] & ~q[7] & ~q[6] & ~q[5] & ~q[4] & ~q[3]& ~q[2] & ~q[1]& q[0];

assign display_en = q[14] & ~q[13] & ~q[12] & ~q[11] & ~q[10] & ~q[9] & ~q[8] & ~q[7] & ~q[6] & ~q[5] & ~q[4] & ~q[3]& ~q[2] & ~q[1]& ~q[0];


assign pix_en = ~q[1] & ~q[0];

endmodule