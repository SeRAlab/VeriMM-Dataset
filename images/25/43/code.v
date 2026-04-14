module mux_16_to_1 (  
    input wire [15:0] I,  
    input wire [3:0] S,  
    output wire Y  
);  
    assign Y = I[S];  
endmodule