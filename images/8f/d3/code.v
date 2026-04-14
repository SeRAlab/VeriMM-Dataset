module top_module(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);reg [7:0] in_reg1, in_reg2;
reg [7:0] anyedge_reg1, anyedge_reg2;

always @(posedge clk) begin
    in_reg1 <= in;
    anyedge_reg1 <= anyedge_reg2;
end

always @(posedge clk) begin
    in_reg2 <= in_reg1;
    anyedge_reg2 <= anyedge_reg1;
end

always @(posedge clk) begin
    anyedge_reg1 <= (in_reg1 ^ in_reg2) & ~anyedge_reg2;
end

assign anyedge = anyedge_reg2;

endmodule