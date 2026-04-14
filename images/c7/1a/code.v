module bitwise_and (
    input a,
    input b,
    input reset,
    input clk,
    output reg out
);

always @(posedge clk, negedge reset) begin
    if (!reset) begin
        out <= 1'b0;
    end else begin
        out <= a & b;
    end
end

endmodule