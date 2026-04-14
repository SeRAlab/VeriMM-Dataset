module top_module(
        input [5:0] numerator,  
        output reg [2:0] quotient, 
        output [3:0] remainder
    );reg [1:0] remainder3to2;
    always @(numerator[5:2])
    case(numerator[5:2])        
         0: begin quotient=0; remainder3to2=0; end
         1: begin quotient=0; remainder3to2=1; end
         2: begin quotient=0; remainder3to2=2; end
         3: begin quotient=1; remainder3to2=0; end
         4: begin quotient=1; remainder3to2=1; end
         5: begin quotient=1; remainder3to2=2; end
         6: begin quotient=2; remainder3to2=0; end
         7: begin quotient=2; remainder3to2=1; end
         8: begin quotient=2; remainder3to2=2; end
         9: begin quotient=3; remainder3to2=0; end
        10: begin quotient=3; remainder3to2=1; end
        11: begin quotient=3; remainder3to2=2; end
        12: begin quotient=4; remainder3to2=0; end
        13: begin quotient=4; remainder3to2=1; end
        14: begin quotient=4; remainder3to2=2; end
        15: begin quotient=5; remainder3to2=0; end
    endcase
    
    assign remainder[1:0] = numerator[1:0];  
    assign remainder[3:2] = remainder3to2;  
    
    endmodule