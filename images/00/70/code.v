module sr_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Q_bar
);
    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1;
            Q_bar <= 0;
        end else if (!S && R) begin
            Q <= 0;
            Q_bar <= 1;
        end else if (!S && !R) begin
            // Hold state
            Q <= Q;
            Q_bar <= Q_bar;
        end else begin
            // Undefined state, can be treated as a reset
            Q <= 0;
            Q_bar <= 1;
        end
    end
endmodule