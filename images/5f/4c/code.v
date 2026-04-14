module top_module(
    input [255:0] in,
    input [7:0] sel,
    input clk,           // Added clk input
    output reg out
);reg [7:0] sel_reg;
reg [7:0] sel_next;

reg [255:0] in_reg [0:7];  // Changed [0:255] to [255:0]
reg [255:0] in_next [0:7]; // Changed [0:255] to [255:0]

integer i;

always @(*) begin
    sel_reg = sel;
end

always @(posedge clk) begin
    sel_next <= sel_reg;
    for (i = 0; i < 8; i = i + 1) begin
        in_next[i] <= in_reg[i];
    end
end

always @(posedge clk) begin
    out <= in_next[sel_next];
    for (i = 0; i < 8; i = i + 1) begin
        in_reg[i] <= in_next[i];
    end
end

endmodule