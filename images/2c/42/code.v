module ripple_carry_adder(input [3:0] A, input [3:0] B, output [4:0] SUM);  
    wire [3:0] carry;  
    assign {carry[0], SUM[3:0]} = A + B;  
    assign SUM[4] = carry[0];  
endmodule