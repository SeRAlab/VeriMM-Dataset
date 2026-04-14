module down_counter_with_underflow(
    input clk,
    input reset,
    input enable,
    output reg [15:0] count,
    output reg underflow
);

always @(posedge clk or posedge reset)
    if (reset) begin
        count <= 16'b1111111111111111; // Reset count to 65535
        underflow <= 0; // Clear underflow flag
    end else if (enable) begin
        if (count == 16'b0000000000000000) begin
            count <= 16'b1111111111111111; // Wrap around to 65535
            underflow <= 1; // Set underflow flag
        end else begin
            count <= count - 1; // Decrement count
            underflow <= 0; // Clear underflow flag
        end
    end

endmodule