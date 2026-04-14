module top_module(
    input clk,
    input clear,
    input parallel_load,
    input [7:0] data,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (clear) begin
            q <= 8'd0;  // Synchronous clear to all zeros
        end else if (parallel_load) begin
            q <= data;  // Synchronous load of the data input
        end
    end

endmodule