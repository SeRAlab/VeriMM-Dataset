module four_bit_adder(  
    input [3:0] A,  
    input [3:0] B,  
    output [4:0] SUM,  
    output C_OUT  
);  
    assign {C_OUT, SUM} = A + B;  
endmodule