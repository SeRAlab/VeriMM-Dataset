module top_module(J,K,Q,Qnot,CP);input J,K,CP;
	output Q,Qnot;
	reg Q;
	
	assign Qnot = ~Q;
	
	always @(posedge CP)
		case({J,K})
			2'b00: Q = Q;
			2'b01: Q = 0;
			2'b10: Q = 1;
			2'b11: Q = ~Q;
			default: ;
		endcase
endmodule