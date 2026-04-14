module top_module(
    input clk,
    input clear,
    input [15:0] d,
    output reg [15:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (clear) begin
            q <= 16'd0;  // Synchronous clear to all zeros
        end else begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule