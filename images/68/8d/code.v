module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);reg [31:0] in_reg1, in_reg2, in_reg3, in_reg4;

always @(posedge clk) begin
    if (reset) begin
        in_reg1 <= 0;
        in_reg2 <= 0;
        in_reg3 <= 0;
        in_reg4 <= 0;
        out <= 0;
    end else begin
        in_reg1 <= in;
        in_reg2 <= in_reg1;
        in_reg3 <= in_reg2;
        in_reg4 <= in_reg3;
        
        if (in_reg4 > in_reg3 && in_reg3 > in_reg2 && in_reg2 > in_reg1) begin
            out <= 32'hFFFFFFFF;
        end else begin
            out <= 0;
        end
    end
end

endmodule