module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output wire Q_bar
);
    assign Q_bar = ~Q;

    always @ (S or R) begin
        if (S && R) begin
            // Invalid state, hold previous state
            Q <= Q;
        end else if (S) begin
            Q <= 1'b1; // Set
        end else if (R) begin
            Q <= 1'b0; // Reset
        end
    end
endmodule