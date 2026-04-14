module register_16bit(
    input clk,
    input reset,
    input enable,
    input load,
    input [15:0] data,
    output reg [15:0] q);

always @(negedge reset, posedge clk) begin
    if (!reset)
        q <= 16'b0000000000000000;
    else if (load)
        q <= data;
    else if (enable)
        q <= q;
end
endmodule