module LU_Decomposition(  
    input clk,  
    input rst,  
    input valid_in,  
    input [15:0] A00, A01, A10, A11,  
    output reg [15:0] L00, L01, L10, L11,  
    output reg [15:0] U00, U01, U10, U11,  
    output reg valid_out  
);  
  
    reg [15:0] A [0:1][0:1];  
    reg [15:0] L [0:1][0:1];  
    reg [15:0] U [0:1][0:1];  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            L00 <= 16'b0; L01 <= 16'b0; L10 <= 16'b0; L11 <= 16'b0;  
            U00 <= 16'b0; U01 <= 16'b0; U10 <= 16'b0; U11 <= 16'b0;  
            valid_out <= 0;  
        end else if (valid_in) begin  
            // Initialize matrices  
            A[0][0] <= A00; A[0][1] <= A01;  
            A[1][0] <= A10; A[1][1] <= A11;  
  
            // LU decomposition  
            L[0][0] <= 16'd1; L[0][1] <= 16'b0;  
            L[1][0] <= A[1][0] / A[0][0]; L[1][1] <= 16'd1;  
  
            U[0][0] <= A[0][0]; U[0][1] <= A[0][1];  
            U[1][0] <= 16'b0; U[1][1] <= A[1][1] - L[1][0] * U[0][1];  
  
            // Assign outputs  
            L00 <= L[0][0]; L01 <= L[0][1];  
            L10 <= L[1][0]; L11 <= L[1][1];  
  
            U00 <= U[0][0]; U01 <= U[0][1];  
            U10 <= U[1][0]; U11 <= U[1][1];  
  
            valid_out <= 1;  
        end  
    end  
endmodule