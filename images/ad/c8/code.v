module top_module(
    input CONTROL,          
    input [4:0] IN0,        
    input [4:0] IN1,        
    output reg [4:0] OUT    
    );always@(CONTROL or IN0 or IN1) begin
        case (CONTROL)
            
            1'b0 : OUT <= IN0;
            
            1'b1 : OUT <= IN1;
            
            default : OUT <= 5'b00000;
        endcase
    end
endmodule