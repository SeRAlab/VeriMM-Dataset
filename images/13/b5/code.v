module SR_FlipFlop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Q_bar
);
    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1;
        end else if (!S && R) begin
            Q <= 0;
        end
        // Keep Q as is when S = 0 and R = 0
        // Do not change Q if S = 1 and R = 1 (keep the previous state)
        Q_bar <= ~Q; // Q_bar is always the complement of Q
    end
endmodule