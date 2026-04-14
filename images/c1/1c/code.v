module N8080_ALU16(
    input [15:0]D0,
    input [7:0]D1,
    input [2:0]OP,	
    output wire[15:0] DOUT
    );
	reg [7:0] mux;
	always @*
		case(OP)
			0: mux = 8'd0;			
			1: mux = 8'd1;			
			2: mux = 8'd2;			
			3: mux = D1;			
			4: mux = 8'd0;			
			5: mux = -8'd1;		
			6: mux = -8'd2;		
			7: mux = 8'dx;
		endcase
	assign DOUT = D0 + {{8{mux[7]}}, mux};
endmodule