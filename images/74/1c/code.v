module top_module(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 8'd0;  // Synchronous reset to all zeros
        end else begin
            q <= d;  // Load the input data into the shift register
        end
    end

endmodule