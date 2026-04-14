module top_module( 
			input signed [7:0] A,B,C,D,E,F
			
			);wire signed [12:0] a0,a1,a2,a3,a4,a5;
wire signed [12:0] P;
wire signed [7:0] avs;
wire signed [7:0] h264;

assign a0=A;
assign a1=B*4'd5;
assign a2=C*6'd20;
assign a3=D*6'd20;
assign a4=E*4'd5;
assign a5=F;
assign P=a0-a1+a2+a3-a4+a5;
assign avs=P*(-1);
assign h264=P;



endmodule