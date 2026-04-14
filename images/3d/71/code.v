module five_input_nor (  
    input wire A,  
    input wire B,  
    input wire C,  
    input wire D,  
    input wire E,  
    output wire Y  
);  
    assign Y = ~(A | B | C | D | E);  
endmodule