module top_module(
    input clk, reset, ce,
    input [31:0] din0, din1,
    output reg [31:0] dout
);reg [31:0] result;

always @(posedge clk) begin
    if (reset) begin
        result <= 0;
        dout <= 0;
    end else if (ce) begin
        result <= din0 * din1;
        dout <= result;
    end
end

endmodule