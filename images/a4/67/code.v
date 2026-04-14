module top_module(
    input clk,
    input shift,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock or the rising edge of reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 8'b0;  // Asynchronous reset to zero
        end else if (shift) begin
            q <= {1'b0, q[7:1]};  // Shift the register to the right
        end else begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule