module Multiplier16x16 (  
    input [15:0] A,  
    input [15:0] B,  
    output reg [31:0] Y  
);  
    always @(*) begin  
        Y = A * B;  
    end  
endmodule