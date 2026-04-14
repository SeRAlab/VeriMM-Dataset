module top_module(SW,LEDR,LEDG);input[17:0]SW;			
	output[17:0]LEDR;		
	output[7:0]LEDG;			
	reg[7:0]OUT;
	
	assign LEDR = SW;
	
	always@(SW)
		case(SW[17:15])
			3'b000 : OUT [2:0] = SW[2:0];
			3'b001 : OUT [2:0] = SW[5:3];
			3'b010 : OUT [2:0] = SW[8:6];
			3'b011 : OUT [2:0] = SW[11:9];
			3'b100 : OUT [2:0] = SW[14:12];
			3'b101 : OUT [2:0] = SW[14:12];
			3'b110 : OUT [2:0] = SW[14:12];
			3'b111 : OUT [2:0] = SW[14:12];
	endcase	
	assign LEDG = OUT;
	
	
	endmodule