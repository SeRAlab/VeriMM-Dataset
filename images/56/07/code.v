module register(
    input [3:0] d,
    input clk,
    input enable,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000; // Reset the register to zero
        end else if (enable) begin
            q <= d; // Load the data into the register
        end
    end

endmodule