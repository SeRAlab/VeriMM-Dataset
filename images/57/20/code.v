module top_module(SEL, D_OUT);input  [1:0] SEL; 
    output reg [3:0] D_OUT;  
       
   
    
    always @ (SEL)
    begin
       case (SEL)
          0: D_OUT = 4'b1110;  
          1: D_OUT = 4'b1101; 
          2: D_OUT = 4'b1011;
          3: D_OUT = 4'b0111;
          default D_OUT = 0; 
       endcase 
    end 
	
	endmodule