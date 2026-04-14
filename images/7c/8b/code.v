module up_counter (
    input clk,
    input reset_n,
    input en,
    input load,
    input [7:0] load_val,
    output reg [7:0] q);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        q <= 8'b00000000;
    else if (load)
        q <= load_val;
    else if (en)
        q <= q + 1;
end

endmodule