module top_module(a, y);input [3:0] a;
output y;
reg [1:0] t1, t2;

always @* begin
	casex (a)
		16'b1xxx:
			t1 <= 1;
		16'bx1xx:
			t1 <= 2;
		16'bxx1x:
			t1 <= 3;
		16'bxxx1:
			t1 <= 4;
		default:
			t1 <= 0;
	endcase
	casex (a)
		16'b1xxx:
			t2 <= 1;
		16'b01xx:
			t2 <= 2;
		16'b001x:
			t2 <= 3;
		16'b0001:
			t2 <= 4;
		default:
			t2 <= 0;
	endcase
end

assign y = t1 != t2;

endmodule