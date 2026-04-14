module SR_Latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Q_bar
);
    always @(S, R) begin
        if (S && !R) begin
            Q <= 1'b1;
            Q_bar <= 1'b0;
        end else if (!S && R) begin
            Q <= 1'b0;
            Q_bar <= 1'b1;
        end
    end
endmodule