module top_module(
    input clk,
    input clear,
    input load,
    input [9:0] data,
    output reg [9:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (clear) begin
            q <= 10'd0;  // Synchronous clear to all zeros
        end else if (load) begin
            q <= data;  // Synchronous load of the data input
        end
    end

endmodule