module four_bit_adder(  
    input [3:0] A,  
    input [3:0] B,  
    input Cin,  
    output [4:0] Sum,  
    output Cout  
);  
    assign {Cout, Sum} = A + B + Cin;  
endmodule