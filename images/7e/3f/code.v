module top_module(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);reg [7:0] anyedge_reg1, anyedge_reg2, anyedge_reg3, anyedge_reg4;

always @(posedge clk) begin
    anyedge_reg1 <= in;
end

always @(posedge clk) begin
    anyedge_reg2 <= anyedge_reg1;
end

always @(posedge clk) begin
    anyedge_reg3 <= anyedge_reg2;
end

always @(posedge clk) begin
    anyedge_reg4 <= anyedge_reg3;
end

assign anyedge = (anyedge_reg1 ^ anyedge_reg2) & anyedge_reg2 & ~anyedge_reg3 & ~anyedge_reg4;

endmodule