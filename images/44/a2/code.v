module top_module(
    input clk,
    input reset,
    input [15:0] A,
    input [15:0] B,
    input select,
    output reg [15:0] S,
    output reg O
);reg [15:0] C;

always @(posedge clk) begin
    if (reset) begin
        S <= 16'b0;
        C <= 16'b0;
        O <= 1'b0;
    end else begin
        if (select) begin // subtraction mode
            S <= A - B - C;
            O <= ~C[15];
            C <= (A < B) | ((A == B) & C);
        end else begin // addition mode
            S <= A + B + C;
            O <= S[16];
            C <= S[16];
        end
    end
end

endmodule