module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Q_not
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state
            Q <= Q; // Maintain previous state
        end else if (S) begin
            Q <= 1'b1; // Set
        end else if (R) begin
            Q <= 1'b0; // Reset
        end
        Q_not <= ~Q; // Complement of Q
    end
endmodule