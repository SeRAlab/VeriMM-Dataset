module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Q_not
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state, do nothing
        end else if (S) begin
            Q <= 1;
            Q_not <= 0;
        end else if (R) begin
            Q <= 0;
            Q_not <= 1;
        end
        // If both S and R are low, retain state
    end
endmodule