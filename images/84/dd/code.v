module ring_counter
(
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b001; // Clear counter to 001
        end else begin
            q <= {q[1:0], q[2]}; // Shift left and wrap-around
        end
    end

endmodule