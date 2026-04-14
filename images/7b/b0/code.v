module top_module(
    input [3:0] A,
    output [3:0] Y
);wire [5:0] shifted_A;
    
    assign shifted_A = {A, 2'b00}; // Shift A left by 2 bits
    
    assign Y = shifted_A[5:2]; // Output the last 4 bits of shifted_A

endmodule