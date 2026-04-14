module top_module(clk, rst_n, branch, branchAddr, instr, stall, globalStall, rd_en, pc, pcNext, hlt, branchInit);input clk, rst_n, branch, stall, globalStall, rd_en;
  input [15:0] branchAddr, instr;
  
  output [15:0] pcNext;   
  output reg [15:0] pc;
  output hlt, branchInit;
  
  reg wasRst_N;

  wire [15:0] effectivePc;

  assign branchInit = !((pc == 16'h0000) || (pc == 16'h0001) || (pc == 16'h0002));

  assign hlt = (instr[15:12] == 4'b1111) && ((!branch) || !branchInit) && rst_n && wasRst_N;

  assign pcNext = !wasRst_N ? 16'h0000 : 
                  stall | globalStall ? pc : 
                  pc + 1; 

  assign effectivePc = (branchInit && branch) ? branchAddr:
                       pcNext;

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      pc <= 16'h0000;
      wasRst_N <= 1'b0;
    end
    else begin
      wasRst_N <= 1'b1;
      if (!hlt)
        pc <= effectivePc;
      else
        pc <= pc;
    end
  end

endmodule