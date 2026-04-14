module two_bit_adder(  
    input wire A1, A0,  
    input wire B1, B0,  
    output wire S1, S0,  
    output wire C  
);  
    assign {C, S0} = A0 + B0;  
    assign {S1} = A1 + B1 + C;  
endmodule