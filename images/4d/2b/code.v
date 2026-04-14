module top_module(input [15:0]DATA , output reg [4:0]count);integer i;
	always @(*)
	begin 
		count = 5'b00000;
		for (i = 0; i<16; i = i+1)
		begin
			if (DATA[i] == 1)
			begin
				count = count + 1;
			end
		end
	end
endmodule