module top_module(
    input clk,
    input left_shift,
    input right_shift,
    input reset,
    input [5:0] d,
    output reg [5:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 6'b0;  // Synchronous reset to zero
        end else if (left_shift) begin
            q <= {q[4:0], d[5]};  // Left shift register
        end else if (right_shift) begin
            q <= {d[0], q[5:1]};  // Right shift register
        end
    end

endmodule