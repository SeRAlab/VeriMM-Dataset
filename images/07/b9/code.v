module d_flip_flop (
    input wire clk,
    input wire reset,
    input wire clk_enable,
    input wire D,
    output reg Q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Q <= 1'b0;
    end else if (clk_enable) begin
        Q <= D;
    end
end

endmodule