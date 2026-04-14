module SR_FF (
    input wire S,
    input wire R,
    output reg Q,
    output reg Q_not
);
always @(S, R) begin
    if (S && R) begin
        // Invalid state, hold previous state
        Q_not = ~Q; // Just to avoid latch inference, but ideally should be handled
    end else if (S) begin
        Q = 1;
    end else if (R) begin
        Q = 0;
    end
    Q_not = ~Q;
end
endmodule