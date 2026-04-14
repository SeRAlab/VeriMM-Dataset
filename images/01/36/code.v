module matrix_multiplier(  
    input [15:0] a, // 2x2 matrix A: a[15:12] a[11:8]  
    input [15:0] b, // 2x2 matrix B: b[15:12] b[11:8]  
    output reg [15:0] result // 2x2 result matrix: result[15:12] result[11:8]  
);  
    always @* begin  
        result[15:12] = (a[15:12] * b[15:12]) + (a[11:8] * b[11:8]); // C[0][0]  
        result[11:8]  = (a[15:12] * b[11:8]) + (a[11:8] * b[15:12]); // C[0][1]  
        result[7:4]   = (a[3:0] * b[15:12]) + (a[7:4] * b[11:8]);  // C[1][0]  
        result[3:0]   = (a[3:0] * b[11:8]) + (a[7:4] * b[15:12]);  // C[1][1]  
    end  
endmodule