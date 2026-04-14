module top_module(
    input [15:0] in,
    input [3:0] sel,
    input EN,
    input clk, // Added clk input
    output reg [3:0] out
);reg [15:0] reg_in [0:1];
reg [3:0] reg_sel [0:1];
reg reg_EN [0:1];

always @(posedge clk) begin
    reg_in[1] <= reg_in[0];
    reg_sel[1] <= reg_sel[0];
    reg_EN[1] <= reg_EN[0];
    
    reg_in[0] <= in;
    reg_sel[0] <= sel;
    reg_EN[0] <= EN;
end

always @(posedge clk) begin
    if (reg_EN[1]) begin
        out <= reg_in[1][4*reg_sel[1] +: 4];
    end else begin
        out <= 4'b0;
    end
end

endmodule