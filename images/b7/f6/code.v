module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    input clk,           // Added clock signal input
    output reg [3:0] S,
    output reg COUT
);reg [3:0] sum1;
reg [3:0] sum2;

always @(*) begin
    sum1[0] = A[0] ^ B[0] ^ CIN;
    sum1[1] = A[1] ^ B[1] ^ sum1[0];
    sum1[2] = A[2] ^ B[2] ^ sum1[1];
    sum1[3] = A[3] ^ B[3] ^ sum1[2];
end

always @(posedge clk) begin
    S <= sum2;         // Update output S on clk
    sum2 <= sum1;      // Pipeline register assignment
    COUT <= (sum1[3] & (sum1[2] | sum1[1] | sum1[0])) | 
             (sum1[2] & (sum1[1] | sum1[0])) | 
             (sum1[1] & sum1[0]);
end

endmodule