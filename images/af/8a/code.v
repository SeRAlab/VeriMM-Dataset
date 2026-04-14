module binary_counter (
    input clk,
    input reset,
    input en,
    input load,
    input [3:0] load_value,
    output reg [3:0] q);always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (load)
        q <= load_value;
    else if (en)
        q <= q + 1;
end
endmodule