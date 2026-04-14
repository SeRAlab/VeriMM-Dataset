module top_module(
    input clk,
    input clear,
    input shift_left,
    input [11:0] data,
    output reg [11:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (clear) begin
            q <= 12'd0;  // Synchronous clear to all zeros
        end else if (shift_left) begin
            q <= {q[10:0], 1'b0};  // Shift left by one bit
        end else begin
            q <= data;  // Load data into the register
        end
    end

endmodule