module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1'b1;      // Set Q
        end else if (!S && R) begin
            Q <= 1'b0;      // Reset Q
        end else if (S && R) begin
            // Forbidden state, keep Q unchanged
        end
        Qn <= ~Q;          // Qn is the complement of Q
    end
endmodule