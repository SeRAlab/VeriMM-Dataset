module mux2to1 (  
    input [3:0] A,  
    input [3:0] B,  
    input S,  
    output reg [3:0] Y  
);  
    always @(*) begin  
        case (S)  
            1'b0: Y = A;  
            1'b1: Y = B;  
            default: Y = 4'b0000;  
        endcase  
    end  
endmodule