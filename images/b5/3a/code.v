module bin_to_gray(
    input clk,
    input reset,
    input [3:0] bin,
    output reg [3:0] gray);always @(posedge clk) begin
    if (reset)
        gray <= 4'b0;
    else
        gray <= (bin >> 1) ^ bin;
end
endmodule