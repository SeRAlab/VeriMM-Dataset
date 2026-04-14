module top_module(input clk,
    input [1:0] io_rs1_thread,
    input [4:0] io_rs1_addr,
    output[31:0] io_rs1_data,
    input [1:0] io_rs2_thread,
    input [4:0] io_rs2_addr,
    output[31:0] io_rs2_data,
    input [1:0] io_rd_thread,
    input [4:0] io_rd_addr,
    input [31:0] io_rd_data,
    input  io_rd_enable
);reg [31:0] dout2;
  wire[31:0] T0;
  wire[31:0] T1;
  reg [31:0] regfile [127:0];
  wire[31:0] T2;
  wire[6:0] T3;
  wire[6:0] T4;
  wire T5;
  reg [31:0] dout1;
  wire[31:0] T6;
  wire[31:0] T7;
  wire[6:0] T8;
  wire T9;

  // Read data from the register file based on the thread identifier and address inputs of each read port
  assign io_rs2_data = dout2;
  assign T0 = T5 ? 32'h0 : T1;
  assign T1 = regfile[T4];
  assign T3 = {io_rd_addr, io_rd_thread};
  assign T4 = {io_rs2_addr, io_rs2_thread};
  assign T5 = io_rs2_addr == 5'h0;
  assign io_rs1_data = dout1;
  assign T6 = T9 ? 32'h0 : T7;
  assign T7 = regfile[T8];
  assign T8 = {io_rs1_addr, io_rs1_thread};
  assign T9 = io_rs1_addr == 5'h0;

  // Write data to the register file based on the thread identifier, address, data inputs, and write enable signal of the write port
  always @(posedge clk) begin
    if(T5) begin
      dout2 <= 32'h0;
    end else begin
      dout2 <= T1;
    end
    if (io_rd_enable)
      regfile[T3] <= io_rd_data;
    if(T9) begin
      dout1 <= 32'h0;
    end else begin
      dout1 <= T7;
    end
    if (io_rd_enable && io_rd_thread == 2'b00)
      regfile[io_rd_addr] <= io_rd_data;
    if (io_rd_enable && io_rd_thread == 2'b01)
      regfile[io_rd_addr+32] <= io_rd_data;
    if (io_rd_enable && io_rd_thread == 2'b10)
      regfile[io_rd_addr+64] <= io_rd_data;
  end
endmodule