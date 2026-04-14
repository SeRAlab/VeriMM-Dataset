module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qbar
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state, do nothing
        end else if (S) begin
            Q <= 1'b1; // Set
            Qbar <= 1'b0;
        end else if (R) begin
            Q <= 1'b0; // Reset
            Qbar <= 1'b1;
        end
    end
endmodule