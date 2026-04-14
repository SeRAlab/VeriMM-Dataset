module top_module(sum,a,b,zout,gin);output [31:0] sum;
input [31:0] a,b; 
input [3:0] gin;
reg [31:0] sum;
reg [31:0] less;
output zout;
reg zout;
always @(a or b or gin)
begin
	case(gin)
	4'b0010: sum=a+b; 		
	4'b0110: sum=a+1+(~b);	
	4'b0111: begin less=a+1+(~b);	
			if (less[31]) sum=1;	
			else sum=0;
		  end
	4'b0000: sum=a & b;	
	4'b0001: sum=a|b;	
	4'b1100: sum=~(a|b);	
	default: sum=31'bx;	
	endcase
zout=~(|sum);
end
endmodule