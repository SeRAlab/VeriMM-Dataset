module carry_save_adder(  
    input [2:0] a,  
    input [2:0] b,  
    input [2:0] c,  
    output [4:0] sum,  
    output [2:0] carry  
);  
    assign sum = a ^ b ^ c;  
    assign carry = (a & b) | (b & c) | (c & a);  
endmodule