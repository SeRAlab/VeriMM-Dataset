module LU_Decomposition (  
    input [15:0] matrix,  // 4x4 matrix elements as 4-bit values  
    output [15:0] L,      // Lower triangular matrix  
    output [15:0] U       // Upper triangular matrix  
);  
    wire [3:0] a, b, c, d;  
    assign {a, b, c, d} = matrix;  
  
    // LU Decomposition Logic  
    assign L[15:12] = 4'b0001; // L11  
    assign L[11:8]  = a / L[15:12]; // L21 = a / L11  
    assign L[7:4]   = 4'b0000; // L12  
    assign L[3:0]   = 4'b0000; // L22  

    assign U[15:12] = a; // U11  
    assign U[11:8]  = b; // U12  
    assign U[7:4]   = c - (L[11:8] * U[15:12]); // U21  
    assign U[3:0]   = d - (L[11:8] * U[11:8]); // U22  
endmodule