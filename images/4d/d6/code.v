module top_module(SW, LEDR);input [9:0] SW;
	output[9:0] LEDR;
	
	reg res;
	wire t,u,v,w,x,y,z;
	wire s2,s1,s0;
	
	assign t = SW[0];
	assign u = SW[1];
	assign v = SW[2];
	assign w = SW[3];
	assign x = SW[4];
	assign y = SW[5];
	assign z = SW[6];

	assign s2 = SW[9];
	assign s1 = SW[8];
	assign s0 = SW[7];
	
	wire RES;
	
	always @(*)
	begin 
		case (SW[9:7])
		
			3'b000: res = t;
			3'b001: res = u;
			3'b010: res = v;
			3'b011: res = w;
			3'b100: res = x;
			3'b101: res = y;
			3'b110: res = z;
			default: res = 1'b0;
		
		endcase
	end
	
	assign RES = res;
	assign LEDR[0] = RES;
	assign LEDR[9:1] = 8'b0;

endmodule