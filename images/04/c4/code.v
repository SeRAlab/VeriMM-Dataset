module LU_Decomposition (  
    input [15:0] A11, A12,  
    input [15:0] A21, A22,  
    output reg [15:0] L11, L12,  
    output reg [15:0] L21, L22,  
    output reg [15:0] U11, U12,  
    output reg [15:0] U21, U22,  
    input clk,  
    input rst  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        L11 <= 16'h0001; // L11 = 1  
        L12 <= 16'h0000; // L12 = 0  
        L21 <= 16'h0000; // L21 = 0  
        L22 <= 16'h0001; // L22 = 1  
        U11 <= A11;  
        U12 <= A12;  
        U21 <= 16'h0000;  
        U22 <= A22;  
    end else begin  
        // LU Decomposition
        L21 <= A21 / U11;  
        U21 <= A21;  
        U22 <= A22 - L21 * U12;  
        L12 <= A12 / U11;  
        U12 <= A12;  
    end  
end  
endmodule