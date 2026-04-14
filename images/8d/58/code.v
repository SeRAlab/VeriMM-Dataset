module down_counter(
    input clk,
    input reset,
    input enable,
    input load,
    input [5:0] data,
    output reg [5:0] q);

always @(negedge reset or posedge clk) begin
    if (!reset)
        q <= 6'b111111;
    else if (load)
        q <= data;
    else if (enable)
        q <= q - 1;
end
endmodule