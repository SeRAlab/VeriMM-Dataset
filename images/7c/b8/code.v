module top_module(a0, a1, a2, a3, addr, y);input  [31:0] a0, a1, a2, a3;
	input  [5:0]  addr;
	output [31:0] y;
	
	reg    [31:0] y;
	always @ (*)
	begin
		case (addr)
			6'b110000: y = a0;
			6'b110001: y = a1;
			6'b110010: y = a2;
			6'b110011: y = a3;
		endcase
	end
endmodule