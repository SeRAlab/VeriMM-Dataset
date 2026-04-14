module top_module(
    input clk,
    input reset,
    input load,
    input [7:0] data,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000;  // Reset the register to 0
        end else if (load) begin
            q <= data;  // Load the input data
        end else begin
            q <= q >> 1;  // Shift right
        end
    end

endmodule