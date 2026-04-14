module top_module(wrtData, p1Addr, regAddr_MEM_WB, regWe_MEM_WB, aluResult_MEM_WB, jal_MEM_WB, pcNext_MEM_WB, memRe_MEM_WB, memData_MEM_WB, forwardWrtData);input [15:0] wrtData, aluResult_MEM_WB, pcNext_MEM_WB, memData_MEM_WB;
  input [3:0] p1Addr, regAddr_MEM_WB;
  input regWe_MEM_WB, jal_MEM_WB, memRe_MEM_WB;
  output [15:0] forwardWrtData;

  assign forwardWrtData = (p1Addr == 4'b0000) ? wrtData : 
                          (regWe_MEM_WB && (p1Addr == regAddr_MEM_WB)) ? (jal_MEM_WB ? pcNext_MEM_WB : (memRe_MEM_WB ? memData_MEM_WB : aluResult_MEM_WB)) :
                          wrtData;

endmodule