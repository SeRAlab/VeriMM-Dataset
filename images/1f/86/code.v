module bitwise_operations (  
    input [7:0] A,  
    input [7:0] B,  
    output [7:0] C,  // C = A AND B  
    output [7:0] D   // D = A OR B  
);  
    assign C = A & B;  
    assign D = A | B;  
endmodule