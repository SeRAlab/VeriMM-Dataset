module d_flip_flop (
    input wire clk,
    input wire clear,
    input wire d,
    output reg q
    );

always @(posedge clk or posedge clear) begin
    if (clear)
        q <= 1'b0;
    else
        q <= d;
end

endmodule