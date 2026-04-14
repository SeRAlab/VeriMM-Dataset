module top_module(
  
  input               clk,
  input               rst,

  
  input               i_m_we,
  input               i_m_stb,
  input               i_m_cyc,
  input       [3:0]   i_m_sel,
  input       [31:0]  i_m_adr,
  input       [31:0]  i_m_dat,
  output reg  [31:0]  o_m_dat,
  output reg          o_m_ack,
  output reg          o_m_int,

  
  output              o_s0_we,
  output              o_s0_cyc,
  output              o_s0_stb,
  output    [3:0]     o_s0_sel,
  input               i_s0_ack,
  output    [31:0]    o_s0_dat,
  input     [31:0]    i_s0_dat,
  output    [31:0]    o_s0_adr,
  input               i_s0_int

);parameter MEM_SEL_0 = 0;
parameter MEM_OFFSET_0  =  0;
parameter MEM_SIZE_0  =  8388607;


reg [31:0] mem_select;

always @(rst or i_m_adr or mem_select) begin
  if (rst) begin
    
    mem_select <= 32'hFFFFFFFF;
  end
  else begin
    if ((i_m_adr >= MEM_OFFSET_0) && (i_m_adr < (MEM_OFFSET_0 + MEM_SIZE_0))) begin
      mem_select <= MEM_SEL_0;
    end
    else begin
      mem_select <= 32'hFFFFFFFF;
    end
  end
end



always @ (mem_select or i_s0_dat) begin
  case (mem_select)
    MEM_SEL_0: begin
      o_m_dat <= i_s0_dat;
    end
    default: begin
      o_m_dat <= 32'h0000;
    end
  endcase
end




always @ (mem_select or i_s0_ack) begin
  case (mem_select)
    MEM_SEL_0: begin
      o_m_ack <= i_s0_ack;
    end
    default: begin
      o_m_ack <= 1'h0;
    end
  endcase
end




always @ (mem_select or i_s0_int) begin
  case (mem_select)
    MEM_SEL_0: begin
      o_m_int <= i_s0_int;
    end
    default: begin
      o_m_int <= 1'h0;
    end
  endcase
end



assign o_s0_we   =  (mem_select == MEM_SEL_0) ? i_m_we: 1'b0;
assign o_s0_stb  =  (mem_select == MEM_SEL_0) ? i_m_stb: 1'b0;
assign o_s0_sel  =  (mem_select == MEM_SEL_0) ? i_m_sel: 4'b0;
assign o_s0_cyc  =  (mem_select == MEM_SEL_0) ? i_m_cyc: 1'b0;
assign o_s0_adr  =  (mem_select == MEM_SEL_0) ? i_m_adr: 32'h0;
assign o_s0_dat  =  (mem_select == MEM_SEL_0) ? i_m_dat: 32'h0;



endmodule