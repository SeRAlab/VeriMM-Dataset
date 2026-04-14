module down_counter (
    input clk,
    input reset_n,
    input en,
    input hold,
    output reg [7:0] q);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        q <= 8'b00000000;
    else if (hold)
        q <= q;
    else if (en)
        q <= q - 1;
end

endmodule