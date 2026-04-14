module top_module(
    input clk,
    input reset_n,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the counter to 4'b0001
            q <= 4'b0001;
        end else begin
            // Ring counter: Shift left and wrap around MSB to LSB
            q <= {q[2:0], q[3]};
        end
    end

endmodule