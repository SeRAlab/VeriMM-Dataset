module top_module(
    input [2047:0] in,
    input [7:0] sel,
    input clk,
    input rst,
    input [1:0] enable,
    output [7:0] out1,
    output [7:0] out2,
    output [7:0] out3,
    output [7:0] out4
);reg [7:0] out1_reg, out2_reg, out3_reg, out4_reg;
reg [7:0] in_reg [0:3];
reg [1:0] enable_reg [0:3];
reg [1:0] sel_reg [0:3];

// 2-to-4 decoder
assign out1 = (enable_reg[0]) ? out1_reg : 8'b0;
assign out2 = (enable_reg[1]) ? out2_reg : 8'b0;
assign out3 = (enable_reg[2]) ? out3_reg : 8'b0;
assign out4 = (enable_reg[3]) ? out4_reg : 8'b0;

always @(posedge clk) begin
    if (rst) begin
        out1_reg <= 8'b0;
        out2_reg <= 8'b0;
        out3_reg <= 8'b0;
        out4_reg <= 8'b0;
        in_reg[0] <= 8'b0;
        in_reg[1] <= 8'b0;
        in_reg[2] <= 8'b0;
        in_reg[3] <= 8'b0;
        sel_reg[0] <= 2'b00;
        sel_reg[1] <= 2'b01;
        sel_reg[2] <= 2'b10;
        sel_reg[3] <= 2'b11;
        enable_reg[0] <= 1'b0;
        enable_reg[1] <= 1'b0;
        enable_reg[2] <= 1'b0;
        enable_reg[3] <= 1'b0;
    end else begin
        // pipeline stage 1
        in_reg[0] <= in[sel_reg[0]*8 +: 8];
        in_reg[1] <= in[sel_reg[1]*8 +: 8];
        in_reg[2] <= in[sel_reg[2]*8 +: 8];
        in_reg[3] <= in[sel_reg[3]*8 +: 8];
        sel_reg[0] <= sel;
        sel_reg[1] <= sel_reg[0];
        sel_reg[2] <= sel_reg[1];
        sel_reg[3] <= sel_reg[2];
        enable_reg[0] <= enable;
        enable_reg[1] <= enable_reg[0];
        enable_reg[2] <= enable_reg[1];
        enable_reg[3] <= enable_reg[2];
        // pipeline stage 2
        out1_reg <= (enable_reg[0]) ? in_reg[0] : out1_reg;
        out2_reg <= (enable_reg[1]) ? in_reg[1] : out2_reg;
        out3_reg <= (enable_reg[2]) ? in_reg[2] : out3_reg;
        out4_reg <= (enable_reg[3]) ? in_reg[3] : out4_reg;
    end
end

endmodule