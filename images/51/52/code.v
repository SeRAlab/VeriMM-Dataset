module top_module(en,ld,rst_n,clk,data,r0_out);input en, ld, rst_n, clk;
input [7:0]data;
reg [7:0] p1_in, p2_in, p1_out, p2_out;
reg [15:0] r0_in;
output reg [15:0] r0_out;
reg p_en, r0_en;
parameter s0=0,s1=1,s2=2;
reg [1:0]ps,ns;

always@(*) begin
p1_in[7:0]<=data[7:0];
p2_in[7:0]<=p1_out;
r0_in[15:8]<=p1_out;
r0_in[7:0]<=p2_out;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) ps <= s0; else ps <= ns;
end

always@(*) begin
	case(ps)
	s0: if(en==1'b0)ns<=s0; else ns<=s1;
	s1: if(en==1'b0)ns<=s1; else ns<=s2;
	s2: if(ld==1'b0)ns<=s1;
		else if(en==1)ns<=s1;
			else ns<=s0;
	default:ns<=s0;
endcase
end

always@(*) begin
	case(ps)
	s0: if(en==1'b0){p_en,r0_en}<=2'b00; else {p_en,r0_en}<=2'b10;
	s1: if(en==1'b0){p_en,r0_en}<=2'b00; else {p_en,r0_en}<=2'b10;
	s2: if(ld==1'b0){p_en,r0_en}<=2'b00;
		else if(en==1'b0){p_en,r0_en}<=2'b01;
			else {p_en,r0_en}<=2'b11;
	default: {p_en,r0_en}<=2'b00;
endcase
end
endmodule