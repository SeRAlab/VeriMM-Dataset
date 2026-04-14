module top_module(DATA1, DATA2, RESULT, ZERO, SELECT);input [0:7]DATA1;           
        input [0:7]DATA2;           
        input [0:2]SELECT;          
	output [0:7]RESULT;         
        output ZERO;
        
        reg [0:7]RESULT;

        assign ZERO = ~(|RESULT);
	
	always @ (DATA1, DATA2, SELECT)
	begin 
                case(SELECT)
                        3'b000    :
			begin 
				#1;                          
				RESULT = DATA2;             
			end
                        3'b001    : 
			begin
				#2;                           
				RESULT = DATA1 + DATA2;     
			end
                        3'b010    : 
			begin
				#1;                          
				RESULT = DATA1 & DATA2;     
			end
			3'b011    : 
			begin
				#1;                           
				RESULT = DATA1 | DATA2;     
			end
                        default   : 
			begin
				RESULT = 8'bX ;             
			end 
                endcase  
       end	
endmodule