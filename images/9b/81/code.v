module top_module(a0,a1,a2,sel_addr,y);input [31:0] a0,a1,a2;
	input [5:0] sel_addr;
	
	output [31:0] y;
	
	reg [31:0] y;
	
	always @ *
	begin
		case (sel_addr)
			6'b110000: y = a0; 
			6'b110001: y = a1; 
			6'b110010: y = a2; 
			default: y = 0;
		endcase
	end
endmodule