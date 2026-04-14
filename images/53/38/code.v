module binary_counter_with_carry_out(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count,
    output reg carry_out
);

always @(posedge clk or posedge reset)
    if (reset) begin
        count <= 4'b0000; // Reset count to 0
        carry_out <= 0; // Clear carry out flag
    end else if (enable) begin
        if (count == 4'b1111) begin
            count <= 4'b0000; // Wrap around to 0
            carry_out <= 1; // Set carry out flag
        end else begin
            count <= count + 1; // Increment count
            carry_out <= 0; // Clear carry out flag
        end
    end

endmodule