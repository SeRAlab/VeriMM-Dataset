module carry_save_adder(  
    input [3:0] A,  
    input [3:0] B,  
    input [3:0] C,  
    output [4:0] SUM,  
    output [3:0] CARRY  
);  
    wire [4:0] temp_sum;  
    wire [3:0] temp_carry;  

    // Perform the first addition of A and B  
    assign temp_sum = A + B;  
    assign temp_carry = (temp_sum[4] == 1) ? 1 : 0;  

    // Add the carry from the first addition to C  
    assign SUM = temp_sum + {temp_carry, C};  
    assign CARRY = (temp_sum[4] == 1) ? (temp_sum[3:0] + C[3:0]) : C;  

endmodule