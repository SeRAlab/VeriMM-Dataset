module top_module(
  input CLK,
  input RST,
  input MEM_WB_RegWre,
  
  input [4:0] MEM_Reg_RD,
  
  
  input [31:0] MEM_ALU_DataBus,
  
  output reg WB_RegWre,
  output reg [31:0] WB_DataBus,
  output reg [4:0] WB_Reg_RD
  );always@(posedge CLK or negedge RST)
  begin
    if(~RST)
      begin
        WB_RegWre <= 0;
        WB_DataBus <= 32'b0;
        WB_Reg_RD <= 5'b0;
      end
    else
      begin
        WB_RegWre <= MEM_WB_RegWre;
        WB_Reg_RD <= MEM_Reg_RD;
        WB_DataBus <= MEM_ALU_DataBus;
        
      end
  end
endmodule