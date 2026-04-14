module top_module(S, in, out);input [2:0]S;
	input [31:0] in;
	output reg [7:0] out;
	
	reg [3:0] into;
	
	always @(S) begin
		case(S[2:0])
			3'b000: into <= in[31:28];
			3'b001: into <= in[27:24];
			3'b010: into <= in[23:20];
			3'b011: into <= in[19:16];
			3'b100: into <= in[15:12];
			3'b101: into <= in[11:8];
			3'b110: into <= in[7:4];
			3'b111: into <= in[3:0];
			default: into <= 4'b0000;
		endcase	
	end
	always @ (S) begin
		case(into)
			4'h0: out <= 8'b00111111;
			4'h1: out <= 8'b00000110;
			4'h2: out <= 8'b01011011;
			4'h3: out <= 8'b01001111;
			4'h4: out <= 8'b01100110;
			4'h5: out <= 8'b01101101;
			4'h6: out <= 8'b01111101;
			4'h7: out <= 8'b00000111;
			4'h8: out <= 8'b01111111;
			4'h9: out <= 8'b01101111;
			4'ha: out <= 8'b01110111;
			4'hb: out <= 8'b01111100;
			4'hc: out <= 8'b00111001;
			4'hd: out <= 8'b01011110;
			4'he: out <= 8'b01111001;
			4'hf: out <= 8'b01110001;
			default: out <= 8'b00000000;
		endcase
	end
endmodule