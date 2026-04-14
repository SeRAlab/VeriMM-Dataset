module top_module(
  input clk,
  input rst,
  input [31:0] btb_target,
  input [31:0] ras_target,
  input id_pc_src,
  input stall,
  input pc_go,
  input [31:0] good_target,
  input [1:0] btb_type,
  input btb_v,
  output [31:0] pc_out,
  output v_pc_out,
  output [31:0] pc_plus4
);// Parameter
  parameter initial_addr = 32'h00040000;
  parameter br_type = 2'b00;
  parameter j_type = 2'b01;
  parameter jal_type = 2'b10;
  parameter jr_type = 2'b11;

  // Reg
  reg [1:0] pc_src;
  reg [31:0] pc_temp;
  reg [31:0] pc;

  // Wire
  wire [1:0] pc_src1;
  wire [31:0] good_target_out;

  // Assign
  assign good_target_out = (id_pc_src == 1'b1) ? good_target : 32'h0;
  assign pc_plus4 = pc + 4;
  assign v_pc_out = (pc_go && !stall);

  // Figure out pc src sel
  assign pc_src1 = (btb_v && (btb_type == br_type || btb_type == j_type || btb_type == jal_type)) ? 2'b11 : (btb_v && btb_type == jr_type) ? 2'b10 : 2'b01;
  always @(*) begin
    case (pc_src)
      2'b00: pc_temp = good_target_out;
      2'b01: pc_temp = pc_plus4;
      2'b10: pc_temp = ras_target;
      2'b11: pc_temp = btb_target;
      default: pc_temp = pc_plus4;
    endcase
  end

  // Reg
  always @(posedge clk) begin
    if (rst) begin
      pc <= initial_addr;
    end else if (pc_go && !stall) begin
      pc <= pc_temp;
    end
  end

  assign pc_out = pc;
endmodule