module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 4'b1000
            q <= 4'b1000;
        end else begin
            // Ring counter: Shift left and wrap around the MSB to LSB
            q <= {q[2:0], q[3]};
        end
    end

endmodule