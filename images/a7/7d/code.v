module top_module(
    input clk,
    input reset,
    output reg [5:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 6'b100000;  // Reset the counter with '1' in the MSB
        end else begin
            q <= {q[0], q[5:1]};  // Rotate right
        end
    end

endmodule