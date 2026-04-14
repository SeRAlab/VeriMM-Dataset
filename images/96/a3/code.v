module top_module(input [3:0] A, B, input Cin, Sub, output [3:0] Sum, Cout);wire [3:0] B_comp; // complement of B
    wire [3:0] temp_sum; // temporary sum
    
    assign B_comp = ~B + 1; // 2's complement of B
    
    // Adder-Subtractor logic
    assign temp_sum = (Sub == 1) ? A + B_comp + Cin : A + B + Cin;
    
    // Output sum and carry
    assign Sum = temp_sum[3:0];
    assign Cout = temp_sum[4];
    
endmodule