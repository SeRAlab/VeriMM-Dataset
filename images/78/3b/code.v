module ring_counter(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset
            q <= 5'b00001;
        end else begin
            // Ring counter logic
            q <= {q[3:0], q[4]};
        end
    end

endmodule