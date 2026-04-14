module down_counter (
    input clk,
    input reset,
    input en,
    input preset,
    input [3:0] preset_val,
    output reg [3:0] q);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (preset)
        q <= preset_val;
    else if (en)
        q <= q - 1;
end

endmodule