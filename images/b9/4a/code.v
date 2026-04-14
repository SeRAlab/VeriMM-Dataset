module top_module(
    input clk,
    input [15:0] in,
    output reg [15:0] anyedge
);reg [15:0] in_reg1, in_reg2;
reg [15:0] out_reg1, out_reg2;

always @(posedge clk) begin
    in_reg1 <= in;
    out_reg1 <= out_reg2;
end

always @(posedge clk) begin
    in_reg2 <= in_reg1;
    out_reg2 <= out_reg1;
end

always @(posedge clk) begin
    if (in_reg2[0] == 1 && in_reg1[0] == 0) begin
        anyedge <= out_reg2;
    end
end

endmodule