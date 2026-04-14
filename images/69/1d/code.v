module top_module(
   Op_i,
	 branch_o,
	 jump_o,
	 mux8_o
);input [5:0]   Op_i;
   output        jump_o;
	 output        branch_o;
	 output[7:0]   mux8_o;

	 reg [9:0]     out;
	 assign jump_o = out[9];
	 assign branch_o = out[8];
	 assign mux8_o = out[7:0];
	 
	 
	 
	 
   
	 
	 always @(*) begin
       case(Op_i)
		     6'b000000: out = 10'b0010000111; 
				 6'b000100: out = 10'b0100000011; 
				 6'b001000: out = 10'b0010001000; 
				 6'b100011: out = 10'b0011101000; 
				 6'b101011: out = 10'b0000011000; 
				 default:   out = 10'b1000000000; 
			 endcase
	 end
	 
   
endmodule