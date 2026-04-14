module d_flip_flop
(
    input clk,
    input rst,
    input set,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 1'b0;
    end else if (set) begin
        q <= 1'b1;
    end else begin
        q <= d;
    end
end

endmodule