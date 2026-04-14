module top_module(
    input clk,    // Clocks are used in sequential circuits
    input reset,  // Synchronous active-high reset
    input d,
    output reg q,
    input a,
    input b,
    output reg out  // Changed from wire to reg
);reg j, k;

// D flip-flop using JK flip-flop
always @(posedge clk, posedge reset) begin
    if (reset) begin
        q <= 1'b0;
        j <= 1'b0;
        k <= 1'b0;
    end else begin
        j <= d;
        k <= ~d;
        q <= j ^ (q & k);
    end
end

// XOR gate
always @(*) begin
    if (a == b) begin
        out = 1'b0;
    end else begin
        out = 1'b1;
    end
end

// AND gate
always @(*) begin
    if (out && q) begin
        out = 1'b1;
    end else begin
        out = 1'b0;
    end
end

endmodule