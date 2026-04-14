module top_module(
    input clk,
    input shift,
    input [7:0] d,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (shift) begin
            q <= {q[6:0], 1'b0};  // Shift the register to the left
        end else begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule