module ring_counter(
    input clk,
    input reset_n,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the ring counter to 5'b00001
            q <= 5'b00001;
        end else begin
            // Ring operation: Circulate the high bit
            q <= {q[3:0], q[4]};
        end
    end

endmodule