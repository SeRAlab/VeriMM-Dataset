module four_bit_adder (  
    input [3:0] A,  
    input [3:0] B,  
    output [4:0] SUM,  
    output COUT  
);  
    assign {COUT, SUM} = A + B;  
endmodule