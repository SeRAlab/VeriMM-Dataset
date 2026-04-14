module mux_2_to_1 (  
    input wire a,  
    input wire b,  
    input wire sel,  
    output wire y  
);  
    assign y = sel ? b : a;  
endmodule