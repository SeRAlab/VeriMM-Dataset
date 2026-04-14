module top_module(A, B, C, Z, D);input [3:0] A;
    input B, C;
    output reg [1:0] Z;
    output reg D;
    
    always @* begin
        Z[1:0] = (A[3:0] & B) | (~A[3:0] & C);
        D = ~A[0];
    end
    
endmodule