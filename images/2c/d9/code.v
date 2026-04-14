module eight_bit_adder(  
    input [7:0] A,  
    input [7:0] B,  
    output [7:0] SUM,  
    output C_OUT  
);  
    assign {C_OUT, SUM} = A + B;  
endmodule