module top_module( I0, I1,I2,I3,S,out);parameter bit_size = 16;

	input  [bit_size-1:0] I0;
	input  [bit_size-1:0] I1;
	input  [bit_size-1:0] I2;
	input  [bit_size-1:0] I3;
	input  [1:0] S;

	output [bit_size-1:0] out;
	reg [bit_size-1:0] out;
	
  
  
	always@ (*) begin
	  
		case (S)
    
		0 : out=I0;
		1 : out=I1;
		2 : out=I2;
		3 : out=I3;
   		default : ;
    
		endcase 
		
	end
	
endmodule