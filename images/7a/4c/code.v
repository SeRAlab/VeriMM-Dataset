module up_counter (
    input clk,
    input reset,
    input en,
    input preset,
    input [13:0] preset_val,
    output reg [13:0] q);

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 14'b00000000000000;
    else if (preset)
        q <= preset_val;
    else if (en)
        q <= q + 1;
end

endmodule