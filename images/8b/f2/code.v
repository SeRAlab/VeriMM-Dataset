module top_module(
	
	input [9:0] bin,

	
	output [11:0] BCD
);reg [3:0] units [2:0];

integer i, j;
always @(bin)
begin
	
	for (j = 2; j >= 0; j = j - 1)
		units[j] = 0;

	
	for (i = 9; i >= 0; i = i - 1) begin

		
		for (j = 2; j >= 0; j = j - 1) begin
			if (units[j] >= 5)
				units[j] = units[j] + 3;
		end
		
		
		
		for (j = 2; j >= 0; j = j - 1) begin
			units[j] = units[j] << 1;
			
			if (j == 0)
				
				
				units[j][0] = bin[i];
			else
				units[j][0] = units[j-1][3];
		end
	end
end


genvar z;
generate
	for (z = 0; z < 3; z = z + 1) begin : assign_BCD
		assign BCD[4*(z+1)-1-:4] = units[z];
	end
endgenerate

endmodule