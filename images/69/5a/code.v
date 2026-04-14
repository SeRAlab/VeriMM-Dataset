module top_module(
    input wire clk,          // Added clk input
    input wire [1:0] A, B,
    output reg [3:0] Y0, Y1, Y2, Y3
);reg [1:0] stage1_A, stage1_B;
reg [1:0] stage2_A, stage2_B;

always @(posedge clk) begin
    stage1_A <= A;
    stage1_B <= B;
    stage2_A <= stage1_A;
    stage2_B <= stage1_B;
end

always @(posedge clk) begin
    case (stage2_A)
        2'b00: begin
            Y0 <= 1'b1;
            Y1 <= 1'b0;
            Y2 <= 1'b0;
            Y3 <= 1'b0;
        end
        2'b01: begin
            Y0 <= 1'b0;
            Y1 <= 1'b1;
            Y2 <= 1'b0;
            Y3 <= 1'b0;
        end
        2'b10: begin
            Y0 <= 1'b0;
            Y1 <= 1'b0;
            Y2 <= 1'b1;
            Y3 <= 1'b0;
        end
        2'b11: begin
            Y0 <= 1'b0;
            Y1 <= 1'b0;
            Y2 <= 1'b0;
            Y3 <= 1'b1;
        end
    endcase
end

endmodule