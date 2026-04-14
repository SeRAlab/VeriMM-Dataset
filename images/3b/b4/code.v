module xor2bit (  
    input [1:0] A,  
    input [1:0] B,  
    output [1:0] Y  
);  
    assign Y = A ^ B;  
endmodule