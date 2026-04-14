module top_module(
    input [3:0] A,
    output [3:0] X
);wire [3:0] shifted_left;
    
    // Shift left by 2 bits using bitwise logic gates
    assign shifted_left[3] = A[1] & A[0];
    assign shifted_left[2] = A[0] & (~A[1]);
    assign shifted_left[1] = (~A[2]) & (~A[1]);
    assign shifted_left[0] = (~A[3]) & (~A[2]);
    
    // Assign output
    assign X = shifted_left;
    
endmodule