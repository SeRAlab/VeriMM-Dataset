module four_bit_adder(  
    input [3:0] A,  
    input [3:0] B,  
    input CARRY_IN,  
    output [4:0] SUM,  
    output CARRY_OUT  
);  
    assign {CARRY_OUT, SUM} = A + B + CARRY_IN;  
endmodule