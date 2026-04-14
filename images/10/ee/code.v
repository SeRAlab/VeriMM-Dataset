module vector_adder(  
    input [3:0] A,  
    input [3:0] B,  
    output [3:0] SUM,  
    output CARRY_OUT  
);  
    assign {CARRY_OUT, SUM} = A + B;  
endmodule