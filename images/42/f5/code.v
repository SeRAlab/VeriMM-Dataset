module top_module(
    input signed [7:0] a,
    input signed [7:0] b,
    input clk,
    input reset,
    output reg signed [15:0] prod
);reg signed [15:0] A; // Changed to 16 bits to hold the result of the sign extension properly
reg signed [15:0] S; // Changed to 16 bits to hold the result of the sign extension properly
reg signed [15:0] P;

always @(*) begin
    A = (a[7] == 1) ? {8'b11111111, a} : {8'b00000000, a};
    S = (b[7] == 1) ? {8'b11111111, b} : {8'b00000000, b};
    P = A * S;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        prod <= 0;
    end else begin
        prod <= P;
    end
end

endmodule