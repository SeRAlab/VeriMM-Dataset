module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;  // Reset the register to zero
        end else if (load) begin
            q <= data;  // Load the input data
        end
    end

endmodule