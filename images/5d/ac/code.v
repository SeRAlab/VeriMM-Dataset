module binary_counter_13bit (
    input clk,
    input reset_n,
    input en,
    output reg [12:0] q);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        q <= 13'b0000000000000;
    else if (en) begin
        q <= q + 1;
    end
end

endmodule