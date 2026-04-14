module top_module(
  input rst,
  input clk,
  input cpu_stall,
  input ex_c_rfw,
  input [1:0] ex_c_wbsource,
  input [1:0] ex_c_drw,
  input [31:0] ex_alu_r,
  input [31:0] ex_rfb,
  input [4:0] ex_rf_waddr,
  input [31:0] ex_jalra,
  input [4:0] ex_rt,
  input [31:0] wb_wdata,
  output reg p_c_rfw,
  output reg [1:0] p_c_wbsource,
  output reg [31:0] p_alu_r,
  output [31:0] dmem_data,
  output reg [4:0] p_rf_waddr,
  output reg [31:0] p_jalra,
  output [31:0] dmem_addr,
  output [1:0] dmem_drw,
  input [31:0] dmem_in,
  output reg [31:0] p_dout
);assign dmem_addr = ex_alu_r;
  assign dmem_drw = ex_c_drw;

  always @(posedge clk) begin
    if (!cpu_stall) begin
      if (rst) begin
        p_c_rfw <= 0;
        p_c_wbsource <= 0;
        p_alu_r <= 0;
        p_rf_waddr <= 0;
        p_jalra <= 0;
        p_dout <= 0;
      end else begin
        p_c_rfw <= ex_c_rfw;
        p_c_wbsource <= ex_c_wbsource;
        p_alu_r <= ex_alu_r;
        p_rf_waddr <= ex_rf_waddr;
        p_jalra <= ex_jalra;
        p_dout <= dmem_in;
      end
    end
  end

  assign dmem_data = (p_c_rfw && (ex_rt == p_rf_waddr) && (p_rf_waddr != 0)) ? wb_wdata : ex_rfb;

endmodule