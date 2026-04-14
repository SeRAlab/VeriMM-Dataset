module mux8to1(  
    input wire [7:0] I,  
    input wire [2:0] S,  
    output wire Y  
);  
    assign Y = I[S];  
endmodule