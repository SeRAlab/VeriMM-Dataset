module four_input_nor_gate(  
    input wire a,  
    input wire b,  
    input wire c,  
    input wire d,  
    output wire y  
);  
    assign y = ~(a | b | c | d);  
endmodule