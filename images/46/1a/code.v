module top_module(
    input A,
    input B,
    input C,
    input clk,        // Added clk input
    output reg [7:0] Y
);reg [2:0] stage1_out;
reg [7:0] stage2_out;

always @(*) begin
    case ({A,B,C})
        3'b000: stage1_out = 3'b000;
        3'b001: stage1_out = 3'b001;
        3'b010: stage1_out = 3'b010;
        3'b011: stage1_out = 3'b011;
        3'b100: stage1_out = 3'b100;
        3'b101: stage1_out = 3'b101;
        3'b110: stage1_out = 3'b110;
        3'b111: stage1_out = 3'b111;
        default: stage1_out = 3'b000;
    endcase
end

always @(posedge clk) begin
    stage2_out <= 1 << stage1_out; // Generates proper 8-bit output
end

always @(posedge clk) begin
    Y <= stage2_out;
end

endmodule