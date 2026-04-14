module top_module(
    input clk,
    input reset,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 8'b00000001
            q <= 8'b00000001;
        end else begin
            // Johnson counter: Shift left and invert the LSB
            q <= {q[6:0], ~q[7]};
        end
    end

endmodule