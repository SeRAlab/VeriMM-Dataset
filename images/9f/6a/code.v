module top_module(
    input clk,
    input signed [15:0] M,
    input signed [15:0] N,
    output reg [3:0] V,
    output reg signed [31:0] P
);reg [15:0] A;
    reg [15:0] B;
    reg [31:0] C;

    // Multiplication module
    always @(negedge clk) begin
        A <= M;
        B <= N;
        C <= A * B;
    end

    // Priority encoder module
    always @(posedge clk) begin
        if (M > N) begin
            V <= 4'b1000;
        end else begin
            V <= 4'b0100;
        end
    end

    // Functional module
    always @* begin
        if (V == 4'b1000) begin
            P <= C;
        end else begin
            P <= (N < 0) ? -N : N;
        end
    end

endmodule