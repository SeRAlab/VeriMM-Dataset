module counter_with_carry_out
(
    input clk,
    input reset,
    output reg [3:0] count,
    output reg carry_out
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000; // Clear counter to 0
            carry_out <= 1'b0; // Clear carry-out
        end else if (count == 4'b1111) begin
            count <= 4'b0000; // Reset counter on overflow
            carry_out <= 1'b1; // Set carry-out on overflow
        end else begin
            count <= count + 1; // Increment counter
            carry_out <= 1'b0; // Clear carry-out
        end
    end

endmodule