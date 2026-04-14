module d_flip_flop(
    input wire clk,
    input wire d,
    input wire clr,
    output reg q
);

always @(posedge clk or posedge clr) begin
    if (clr) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule