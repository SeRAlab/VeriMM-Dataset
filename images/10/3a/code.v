module four_bit_adder(  
    input [3:0] A,  
    input [3:0] B,  
    output [3:0] SUM,  
    output CARRY_OUT  
);  
    wire [4:0] temp_sum;  
    assign temp_sum = A + B;  
    assign SUM = temp_sum[3:0];  
    assign CARRY_OUT = temp_sum[4];  
endmodule