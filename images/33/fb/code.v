module matrix_mult_2x2(  
    input [3:0] A,  // 2x2 matrix A in row-major order  
    input [3:0] B,  // 2x2 matrix B in row-major order  
    output reg [3:0] C   // Resulting 2x2 matrix C in row-major order  
);  
    always @(*) begin  
        // Extracting matrix elements  
        // A = [A[3:2], A[1:0]] => A[0][0], A[0][1], A[1][0], A[1][1]  
        // B = [B[3:2], B[1:0]] => B[0][0], B[0][1], B[1][0], B[1][1]  
        
        // C[0][0] = A[0][0]*B[0][0] + A[0][1]*B[1][0]  
        // C[0][1] = A[0][0]*B[0][1] + A[0][1]*B[1][1]  
        // C[1][0] = A[1][0]*B[0][0] + A[1][1]*B[1][0]  
        // C[1][1] = A[1][0]*B[0][1] + A[1][1]*B[1][1]  

        C[3:2] = (A[3:2] & {2{B[3]}}) + (A[1:0] & {2{B[1]}});  // C[0][0]
        C[1:0] = (A[3:2] & {2{B[2]}}) + (A[1:0] & {2{B[0]}});  // C[0][1]
        C[3:2] = (A[1:0] & {2{B[3]}}) + (A[3:2] & {2{B[1]}});  // C[1][0]
        C[1:0] = (A[1:0] & {2{B[2]}}) + (A[3:2] & {2{B[0]}});  // C[1][1]  
    end  
endmodule