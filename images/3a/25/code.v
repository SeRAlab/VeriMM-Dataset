module sr_flip_flop (
    input wire clk,
    input wire S,
    input wire R,
    output reg Q,
    output wire Qn
);
    assign Qn = ~Q;

    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1; // Set
        end else if (!S && R) begin
            Q <= 0; // Reset
        end
        // If both S and R are low, Q holds its state
        // If both S and R are high, Q holds its state (undefined behavior)
    end
endmodule