module top_module(
	input signed[7:0] a,
	input signed[7:0] b,
	input [1:0] sel,
	output reg signed [7:0] f,
	output reg ovf,
	output reg take_branch);always@(a, b, sel)
	begin
		case(sel)
			3'b000:
			begin
			 	f = a+b;  take_branch = 0;
			 end
			3'b001: 
				begin
				 	f = ~b;  take_branch = 0;
				 end
			3'b010: 
				begin
				 	f = a&b;  take_branch = 0;
				 end
			3'b011: 
				begin
				 	f = a|b;  take_branch = 0;
				 end
			3'b100: 
				begin
				 	f = a>>>1;  take_branch = 0;
				 end
			3'b101: 
				begin
				 	f = a<<1;  take_branch = 0;
				 end
			3'b110: 
				begin
				 	f = 0;  take_branch = (a==b);
				 end
			3'b111: 
				begin
				 	f = 0;  take_branch = (a!=b);
				 end
			default:
				begin
					f=0;  ovf=0;  take_branch=0;
				end
		endcase
		ovf = (sel==0) && ((a[7] && b[7] && ~f[7]) || (~a[7] && ~b[7] && f[7]));
	end

endmodule