module top_module(
    input clk,
    input reset,
    input [3:0] in,
    output reg [3:0] out
);reg [3:0] delay_reg1;
reg [3:0] delay_reg2;

always @(posedge clk) begin
    if (reset) begin
        delay_reg1 <= 4'b0;
        delay_reg2 <= 4'b0;
        out <= 4'b0;
    end else begin
        delay_reg1 <= in;
        delay_reg2 <= delay_reg1;
        out <= delay_reg2;
    end
end

endmodule