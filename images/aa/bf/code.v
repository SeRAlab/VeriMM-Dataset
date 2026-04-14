module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 5'b00001
            q <= 5'b00001;
        end else begin
            // Ring counter: Rotate left
            q <= {q[3:0], q[4]};
        end
    end

endmodule