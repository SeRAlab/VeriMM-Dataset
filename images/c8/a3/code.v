module d_flip_flop (
    input clk,
    input rst,
    input d,
    output reg q
);

always @(posedge clk, negedge rst) begin
    if (~rst) begin
        q <= 1;
    end else begin
        q <= ~d;
    end
end

endmodule