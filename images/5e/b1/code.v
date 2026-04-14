module top_module(brancheq,sum,a,b,zout,gin,notor);output [31:0] sum;
input [31:0] a,b; 
input [2:0] gin;
input brancheq,notor;
reg [31:0] sum;
reg [31:0] less;
output zout;
reg zout;
always @(a or b or gin)
begin
	case(gin)
	3'b010: sum=a+b; 		
	3'b110: sum=a+1+(~b);	
	3'b111: begin less=a+1+(~b);	
			if (less[31]) sum=1;	
			else sum=0;
			end
	3'b000: sum=a & b;	
	3'b001: sum = notor ? ~(a|b): a|b;		
	3'b011: sum=a+1+(~b);  
	3'b100: begin  
			zout= brancheq ? (a==0 ? 1:((~a[31]) ? 1:0)):((~a[31]) ? (a==0 ? 0:1):0); 
			sum = a; end 
	3'b101: begin 
			zout= brancheq ? (a==0 ? 1:(a[31] ? 1:0)):(a[31] ? (a==0 ? 0:1):0);  
			sum = a; end 
	default: sum=31'bx;	
	endcase


zout= gin!=3'b011 ? (gin==3'b100 ? zout:(gin==3'b101 ? zout : ~(|sum))):(|sum);
end
endmodule