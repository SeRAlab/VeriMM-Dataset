module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output [3:0] S,
    output COUT
);reg [3:0] sum1, sum2, sum3;
reg [3:0] carry1, carry2, carry3;

assign S = sum3;
assign COUT = carry3;

// Pipeline stage 1
always @(*) begin
    sum1 = A + B;
    carry1 = A[3] & B[3];
end

// Pipeline stage 2
always @(*) begin
    sum2 = sum1 + CIN;
    carry2 = sum1[3] & CIN;
end

// Pipeline stage 3
always @(*) begin
    sum3 = sum2 + carry1;
    carry3 = carry2 | (sum2[3] & carry1);
end

endmodule