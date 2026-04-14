module top_module(
    input [3:0] A,
    input clk,           // Added clk as an input
    output reg [3:0] Q
);reg [3:0] gray1, gray2, gray3;

always @ (posedge clk) begin
    gray1 <= A;
end

always @ (posedge clk) begin
    gray2[0] <= A[0] ^ A[1];
    gray2[1] <= A[1] ^ A[2];
    gray2[2] <= A[2] ^ A[3];
    gray2[3] <= A[3];
end

always @ (posedge clk) begin
    gray3[0] <= gray1[0] ^ gray1[1];
    gray3[1] <= gray1[1] ^ gray1[2];
    gray3[2] <= gray1[2] ^ gray1[3];
    gray3[3] <= gray1[3];
end

always @ (posedge clk) begin
    Q <= gray3;
    gray1 <= gray2;
end

endmodule