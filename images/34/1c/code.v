module four_bit_adder(  
    input [3:0] A,  
    input [3:0] B,  
    output [4:0] Sum  
);  
    assign Sum = A + B;  
endmodule