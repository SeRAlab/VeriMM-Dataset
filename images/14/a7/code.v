module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Q_bar
);
    always @(S or R) begin
        if (S == 1 && R == 0) begin
            Q = 1;
            Q_bar = 0;
        end else if (S == 0 && R == 1) begin
            Q = 0;
            Q_bar = 1;
        end
        // Hold the state
    end
endmodule