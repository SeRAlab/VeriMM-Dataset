module mux2to1(  
    input wire A,  
    input wire B,  
    input wire S,  
    output wire Y  
);  
    assign Y = S ? B : A;  
endmodule