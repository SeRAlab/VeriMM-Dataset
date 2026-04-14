module binary_counter_16bit(
    input clk,
    input reset,
    input load,
    input [15:0] init_val,
    output reg [15:0] out
);

always @(posedge clk)
begin
    if (reset)
        out <= 16'b0000000000000000; // Reset to 0
    else if (load)
        out <= init_val; // Load initial value
    else
        out <= out + 1; // Increment counter
end

endmodule