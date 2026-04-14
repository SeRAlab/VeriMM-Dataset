module mux_2_to_1 (  
    input wire A,  
    input wire B,  
    input wire S,  
    output wire Y  
);  
    assign Y = (S) ? B : A;  
endmodule