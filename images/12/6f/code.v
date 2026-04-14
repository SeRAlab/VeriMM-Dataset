module three_input_xor (  
    input wire a,  
    input wire b,  
    input wire c,  
    output wire y  
);  
    assign y = a ^ b ^ c;  
endmodule