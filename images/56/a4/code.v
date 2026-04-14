module top_module(
    input clk,
    input reset,
    input [7:0] d,
    input load,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 8'hFF;  // Synchronous reset to all ones
        end else if (load) begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule