module top_module(
    input clk,
    input [31:0] A,
    input [31:0] B,
    input load,
    output reg [63:0] C
);reg [15:0] A0, A1, A2, B0, B1, B2;
reg [31:0] P0, P1, P2;

always @(posedge clk) begin
    if (load) begin
        A0 <= A[15:0];
        A1 <= A[31:16];
        A2 <= 16'h0;
        B0 <= B[15:0];
        B1 <= B[31:16];
        B2 <= 16'h0;
        C <= 64'h0;
    end else begin
        P0 <= A0 * B0;
        P1 <= A1 * B1;
        P2 <= A2 * B2;
        C <= {P2[31:0], P1[47:16], P0[63:32]} + C;
        A0 <= A[31:16];
        A1 <= A2;
        A2 <= 16'h0;
        B0 <= B[31:16];
        B1 <= B2;
        B2 <= 16'h0;
    end
end

always @(posedge clk) begin
    if (!load) begin
        A2 <= A[47:32];
        B2 <= B[47:32];
        P0 <= A1 * B0;
        P1 <= A2 * B1;
        P2 <= A2 * B2;
        C <= {P2[31:0], P1[47:16], P0[63:32]} + C;
    end
end

endmodule