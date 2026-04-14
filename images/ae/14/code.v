module top_module(A, B, C, D, sel, Y);input A, B, C, D;
input [1:0] sel;
output reg Y;

always @ (sel or A or B or C or D)
begin

	if (sel == 0)
		Y <= A;
	else
	begin
		if (sel == 1)
			Y <= B;
		else
		begin
			if (sel == 2)
				Y <= C;
			else
			begin
				if (sel == 3)
					Y <= D;
				else
					Y <= 1'bx;
			end
		end
	end
end

endmodule