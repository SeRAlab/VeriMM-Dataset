module top_module(
    input clk,
    input load,
    input clear,
    input [3:0] data_in,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (clear) begin
            q <= 4'b0000;  // Clear the register to 0
        end else if (load) begin
            q <= data_in;  // Load the input value to the register
        end
    end

endmodule