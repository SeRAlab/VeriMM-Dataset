module top_module(
    input clk,
    input reset,
    input SaltoCond,
    input signed [31:0] extSigno,
    input oZero,
    output reg [31:0] direinstru
);always @(posedge clk) begin
        if (reset) begin
            direinstru <= 32'b0;
        end else begin
            direinstru <= direinstru + 32'b100;
            if (SaltoCond && !oZero) begin
                direinstru <= extSigno << 2;
            end
        end
    end

endmodule