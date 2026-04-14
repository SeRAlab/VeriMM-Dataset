module SR_FlipFlop (
    input wire clk,
    input wire S,
    input wire R,
    output reg Q,
    output reg Q_bar
);
    always @(posedge clk) begin
        if (S && ~R) begin
            Q <= 1;
            Q_bar <= 0;
        end else if (~S && R) begin
            Q <= 0;
            Q_bar <= 1;
        end else if (S && R) begin
            // Invalid state, retain previous state
            Q <= Q;
            Q_bar <= Q_bar;
        end
    end
endmodule