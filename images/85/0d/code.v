module top_module(
    input clk,
    input clear,
    input shift_right,
    input [7:0] data,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (clear) begin
            q <= 8'd0;  // Synchronous clear to all zeros
        end else if (shift_right) begin
            q <= {1'b0, q[7:1]};  // Shift right by one bit
        end else begin
            q <= data;  // Load data into the register
        end
    end

endmodule