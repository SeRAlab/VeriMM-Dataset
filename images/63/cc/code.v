module johnson_counter_10bit(
    input clk,
    input reset,
    output reg [9:0] out
);

always @(posedge clk)
begin
    if (reset)
        out <= 10'b0000000000; // Reset to 0
    else
        out <= {~out[0], out[9:1]}; // Shift and invert MSB
end

endmodule