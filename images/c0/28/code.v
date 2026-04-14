module ALU16(
    input [15:0]D0,
    input [7:0]D1,
    input [2:0]OP,	
    output [15:0]DOUT
    );
	reg [7:0] mux;
	always @*
		case(OP)
			0: mux = 8'h00;	
			1: mux = 8'h01;	
			2: mux = 8'h02;	
			3: mux = D1;		
			4: mux = 8'h00;	
			5: mux = 8'hff;	
			6: mux = 8'hfe;	
			default: mux = 8'hxx;
		endcase
	assign DOUT = D0 + {{8{mux[7]}}, mux};
endmodule