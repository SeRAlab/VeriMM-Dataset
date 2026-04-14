module johnson_counter (
    input clk,
    input reset,
    input enable,
    output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b00000; // Reset counter to 0
    end else if (enable) begin
        q <= {~q[4], q[4:1]}; // Shift and invert the last bit
    end
end

endmodule