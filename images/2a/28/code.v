module counter (
    input clk,
    input reset,
    output reg [1:0] state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Reset state to 0
        end else begin
            state <= (state == 2'b11) ? 2'b00 : state + 1; // Increment state or wrap around
        end
    end
endmodule