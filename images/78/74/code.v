module top_module(
  input clk,
  input rst,
  input [31:0] pmem_adr_o,
  input pmem_cyc_o,
  input pmem_stb_o,
  input [31:0] pmain_dat_o,
  input [31:0] pexc_dat_o,
  input pmain_ack_o,
  input pexc_ack_o,
  input pmain_stall_o,
  input pexc_stall_o,
  output reg [31:0] pmem_dat_i,
  output reg pmem_ack_i,
  output reg pmem_stall_i
);reg [1:0] pmain_wr;
  reg [1:0] pmain_rd;
  reg [1:0] pexc_wr;
  reg [1:0] pexc_rd;
  wire pmem_mux;

  assign pmem_dat_i = pmem_mux ? pexc_dat_o : pmain_dat_o;
  assign pmem_ack_i = pmem_mux ? pexc_ack_o : pmain_ack_o;
  assign pmem_stall_i = pmem_mux ? pexc_stall_o : pmain_stall_o;

  always @(posedge clk) begin
    if (rst) begin
      pmain_wr <= 0;
      pmain_rd <= 0;
      pexc_wr <= 0;
      pexc_rd <= 0;
    end else begin
      pmain_wr <= !pmain_stall_o && pmem_stb_o && (pmem_adr_o[31:28] == 4'hB) ? pmain_wr + 1'b1 : pmain_wr;
      pmain_rd <= pmain_ack_o ? pmain_rd + 1'b1 : pmain_rd;
      pexc_wr <= !pexc_stall_o && pmem_stb_o && (pmem_adr_o[31:28] == 4'h8) ? pexc_wr + 1'b1 : pexc_wr;
      pexc_rd <= pexc_ack_o ? pexc_rd + 1'b1 : pexc_rd;
    end
  end

  assign pmem_mux = (pmem_adr_o[31:28] == 4'h8 && pmain_wr == pmain_rd) || (pmem_adr_o[31:28] == 4'hB && pexc_wr != pexc_rd);

endmodule