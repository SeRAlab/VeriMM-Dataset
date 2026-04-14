module top_module(clk, reset,
             rn, we, din, dout,
             psw, psw_we, psw_new,
             tlb_index, tlb_index_we, tlb_index_new,
             tlb_entry_hi, tlb_entry_hi_we, tlb_entry_hi_new,
             tlb_entry_lo, tlb_entry_lo_we, tlb_entry_lo_new,
             mmu_bad_addr, mmu_bad_addr_we, mmu_bad_addr_new);input clk;
    input reset;
    input [2:0] rn;
    input we;
    input [31:0] din;
    output [31:0] dout;
    output [31:0] psw;
    input psw_we;
    input [31:0] psw_new;
    output [31:0] tlb_index;
    input tlb_index_we;
    input [31:0] tlb_index_new;
    output [31:0] tlb_entry_hi;
    input tlb_entry_hi_we;
    input [31:0] tlb_entry_hi_new;
    output [31:0] tlb_entry_lo;
    input tlb_entry_lo_we;
    input [31:0] tlb_entry_lo_new;
    output [31:0] mmu_bad_addr;
    input mmu_bad_addr_we;
    input [31:0] mmu_bad_addr_new;

  
  
  
  
  
  
  
  

  reg [31:0] sr[0:7];

  assign dout = sr[rn];
  assign psw = sr[0];
  assign tlb_index = sr[1];
  assign tlb_entry_hi = sr[2];
  assign tlb_entry_lo = sr[3];
  assign mmu_bad_addr = sr[4];

  always @(posedge clk) begin
    if (reset == 1) begin
      sr[0] <= 32'h00000000;
    end else begin
      if (we == 1) begin
        sr[rn] <= din;
      end else begin
        if (psw_we) begin
          sr[0] <= psw_new;
        end
        if (tlb_index_we) begin
          sr[1] <= tlb_index_new;
        end
        if (tlb_entry_hi_we) begin
          sr[2] <= tlb_entry_hi_new;
        end
        if (tlb_entry_lo_we) begin
          sr[3] <= tlb_entry_lo_new;
        end
        if (mmu_bad_addr_we) begin
          sr[4] <= mmu_bad_addr_new;
        end
      end
    end
  end

endmodule