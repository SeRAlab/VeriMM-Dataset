module top_module(
  input [31:0] E_src1,
  input [31:0] E_src2,
  input M_en,
  input clk,
  input reset_n,
  output reg [31:0] M_mul_cell_p1,
  output reg [31:0] M_mul_cell_p2,
  output reg [31:0] M_mul_cell_p3
);wire [15:0] src1_lsb = E_src1[15:0];
  wire [15:0] src1_msb = E_src1[31:16];
  wire [15:0] src2_lsb = E_src2[15:0];
  wire [15:0] src2_msb = E_src2[31:16];
  
  wire [31:0] mul_p1;
  wire [31:0] mul_p2;
  wire [31:0] mul_p3;

  // Use behavioral multiplication instead of unknown module
  assign mul_p1 = (M_en && !reset_n) ? (src1_lsb * src2_lsb) : 32'd0;
  assign mul_p2 = (M_en && !reset_n) ? (src1_lsb * src2_msb) : 32'd0;
  assign mul_p3 = (M_en && !reset_n) ? (src1_msb * src2_lsb) : 32'd0;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      M_mul_cell_p1 <= 32'd0;
      M_mul_cell_p2 <= 32'd0;
      M_mul_cell_p3 <= 32'd0;
    end else begin
      M_mul_cell_p1 <= mul_p1;
      M_mul_cell_p2 <= {mul_p1[31:16] + mul_p2[15:0] + mul_p3[15:0]};
      M_mul_cell_p3 <= mul_p3;
    end
  end

endmodule