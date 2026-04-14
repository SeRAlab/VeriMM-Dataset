module up_counter (
    input clk,
    input reset,
    input en,
    input load,
    input [31:0] load_val,
    output reg [31:0] q);

always @(posedge clk) begin
    if (reset)
        q <= 32'b00000000000000000000000000000000;
    else if (load)
        q <= load_val;
    else if (en)
        q <= q + 1;
end

endmodule