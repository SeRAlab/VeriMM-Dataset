module d_flip_flop (
    input D,
    input clk,
    input reset,
    input enable,
    output reg Q
);

always @(posedge clk or posedge reset) begin
    if (reset)
        Q <= 1'b0;
    else if (enable)
        Q <= D;
end

endmodule