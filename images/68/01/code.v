module binary_counter_4bit(
    input clk,
    input reset,
    output reg [3:0] out
);

always @(posedge clk)
begin
    if (reset)
        out <= 4'b0000; // Reset to 0
    else
        out <= out + 1; // Increment counter
end

endmodule