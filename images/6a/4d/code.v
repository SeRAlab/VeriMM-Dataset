module top_module(
    input clk,
    input load,
    input clear,
    input [15:0] d,
    output reg [15:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (clear) begin
            q <= 16'b0;  // Synchronous clear to zero
        end else if (load) begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule