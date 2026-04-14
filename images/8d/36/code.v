module top_module(
    input A,
    input B,
    input clk,             // Added clk input
    output reg [15:0] O    // Changed O to reg
);reg [1:0] stage1;
reg [1:0] stage2;

always @(*) begin
    stage1[0] = A;
    stage1[1] = B;
end

always @(posedge clk) begin
    stage2 <= stage1;
end

always @(*) begin
    case (stage2)
        2'b00: O = 16'b0000000000000001;
        2'b01: O = 16'b0000000000000010;
        2'b10: O = 16'b0000000000000100;
        2'b11: O = 16'b0000000000001000;
        default: O = 16'b0000000000000000;
    endcase
end

endmodule