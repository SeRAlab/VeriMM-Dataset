module adder_5bit (  
    input [4:0] a,  
    input [4:0] b,  
    output [5:0] sum,  
    output carry_out  
);  
    assign {carry_out, sum} = a + b;  
endmodule