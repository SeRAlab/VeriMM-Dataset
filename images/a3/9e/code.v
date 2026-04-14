module down_counter_with_underflow(
    input clk,
    input reset,
    input enable,
    output reg [5:0] count,
    output reg underflow
);

always @(posedge clk or posedge reset)
    if (reset) begin
        count <= 6'b111111; // Reset count to 63
        underflow <= 0; // Clear underflow flag
    end else if (enable) begin
        if (count == 6'b000000) begin
            count <= 6'b111111; // Wrap around to 63
            underflow <= 1; // Set underflow flag
        end else begin
            count <= count - 1; // Decrement count
            underflow <= 0; // Clear underflow flag
        end
    end

endmodule