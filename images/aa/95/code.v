module top_module(
    input clk,
    input enable,
    input reset,
    output reg [3:0] q
);reg [3:0] q_reg1, q_reg2;

always @(posedge clk) begin
    if (reset) begin
        q_reg1 <= 4'b0;
        q_reg2 <= 4'b0;
    end
    else if (enable) begin
        q_reg1 <= q_reg2 + 1;
        q_reg2 <= q_reg1;
    end
end

assign q = (q_reg1 == 4'b0110) ? 4'b0000 : q_reg1;

endmodule