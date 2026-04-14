module ring_counter
(
    input clk,
    input reset,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0001; // Initialize counter
        end else begin
            q <= {q[2:0], q[3]}; // Rotate bit
        end
    end

endmodule