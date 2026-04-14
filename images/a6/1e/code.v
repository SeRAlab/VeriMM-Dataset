module top_module(
    input clk,
    input shift,
    input reset,
    input [3:0] d,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0;  // Synchronous reset to zero
        end else if (shift) begin
            q <= {q[2:0], d[3]};  // Left shift register
        end
    end

endmodule