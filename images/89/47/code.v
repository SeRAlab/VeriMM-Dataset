module top_module(
  input wire clk,
  input wire rst,
  input wire [5:0] stall,
  input wire flush,
  input wire [31:0] new_pc,
  input wire branch_flag_i,
  input wire [31:0] branch_target_address_i,
  output reg [31:0] pc,
  output reg ce
);// Registers to store the pipeline stage values
  reg [31:0] pc_reg;
  reg [31:0] pc_next;

  // Combinational logic to compute the next value of the PC register
  always @(*) begin
    if (flush) begin
      pc_next = new_pc;
    end else if (stall[0] == 0) begin
      if (branch_flag_i) begin
        pc_next = branch_target_address_i;
      end else begin
        pc_next = pc_reg + 4;
      end
    end else begin
      pc_next = pc_reg;
    end
  end

  // Registers to store the control signals
  reg ce_reg;
  reg ce_next;

  // Sequential logic to update the PC register and control signals
  always @(posedge clk) begin
    if (rst) begin
      pc_reg <= 0;
      ce_reg <= 0;
    end else begin
      pc_reg <= pc_next;
      ce_reg <= ce_next;
    end
  end

  // Combinational logic to compute the next value of the control signals
  always @(*) begin
    ce_next = (stall == 0) ? 1 : 0;
  end

  // Assign outputs
  assign pc = pc_reg;
  assign ce = ce_reg;

endmodule