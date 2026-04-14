module adder_32bit (  
    input [31:0] A,  
    input [31:0] B,  
    output [31:0] S,  
    output carry_out  
);  
    assign {carry_out, S} = A + B;  
endmodule