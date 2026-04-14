module top_module(
    input clk,
    input enable,
    input [11:0] d,
    output reg [11:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (enable) begin
            q <= d;  // Load the input data into the register when enabled
        end
    end

endmodule