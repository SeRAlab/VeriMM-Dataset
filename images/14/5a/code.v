module xor4_input (  
    input wire a,  
    input wire b,  
    input wire c,  
    input wire d,  
    output wire out  
);  
    assign out = a ^ b ^ c ^ d;  
endmodule