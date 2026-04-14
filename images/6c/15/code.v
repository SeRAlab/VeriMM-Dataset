module top_module(
    input clk,
    input reset,
    input enable,
    input [3:0] data_in,
    output reg [3:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;  // Asynchronously reset the register to 0
        end else if (enable) begin
            q <= data_in;  // Load the input value to the register
        end
    end

endmodule