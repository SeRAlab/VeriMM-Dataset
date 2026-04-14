module johnson_counter(
    input clk,
    input reset_n,
    output reg [6:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the Johnson counter to 7'b0000000
            q <= 7'b0000000;
        end else begin
            // Johnson counter operation: Recirculate the inverted output
            q <= {~q[0], q[6:1]};
        end
    end

endmodule