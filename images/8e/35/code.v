module top_module(
    input A,
    input B,
    input EN,
    input clk,          // Added input for clock signal
    output reg [3:0] Y
);reg [1:0] stage1_A;
reg [1:0] stage1_B;
reg stage2_EN;

always @(posedge clk) begin
    stage1_A <= {A, 1'b0}; // Pack A with an additional bit for 2-bit signal
    stage1_B <= {B, 1'b0}; // Pack B with an additional bit for 2-bit signal
    stage2_EN <= EN;
end

always @(posedge clk) begin
    if (stage2_EN) begin
        case ({stage1_A, stage1_B})
            2'b00: Y <= 4'b0001;
            2'b01: Y <= 4'b0010;
            2'b10: Y <= 4'b0100;
            2'b11: Y <= 4'b1000;
        endcase
    end else begin
        Y <= 4'b0000;
    end
end

endmodule