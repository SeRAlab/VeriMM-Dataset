module top_module(clk, sentido, out);input clk, sentido;
output reg[3:0]out;




reg[3:0]count;

parameter s1=1, s2=2, s3=3, s4=4, s5=5, s6=6, s7=7, s8=8;

always@(count) begin

case(count)
	s1:out=4'b1000;
	s2:out=4'b1100;
	s3:out=4'b0100;
	s4:out=4'b0110;
	s5:out=4'b0010;
	s6:out=4'b0011;
	s7:out=4'b0001;
	s8:out=4'b1001;
endcase
end	

always @ (posedge clk) begin
	
	case(count)

	s1:if(sentido)
			count<=s2;
		else
			count<=s8;
	s2:if(sentido)
			count<=s3;
		else
			count<=s1;
	s3:if(sentido)
			count<=s4;
		else
			count<=s2;
	s4:if(sentido)
			count<=s5;
		else
			count<=s3;
	s5:if(sentido)
			count<=s6;
		else
			count<=s4;
	s6:if(sentido)
			count<=s7;
		else
			count<=s5;
	s7:if(sentido)
			count<=s8;
		else
			count<=s6;
	s8:if(sentido)
			count<=s1;
		else
			count<=s7;	
	endcase	
end

endmodule