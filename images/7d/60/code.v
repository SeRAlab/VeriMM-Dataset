module top_module(input clock,input reset,
  input [7:0] ALU_out,
  input [7:0] EX_WB_Rsdata_in,
  input [2:0] EX_WB_Rd_in,
  input EX_WB_write_mux_in,EX_WB_regWrite_in, 
  output reg [7:0] ALU_WB_out,
  output reg [7:0] EX_WB_Rsdata_out,
  output reg [2:0] EX_WB_Rd_out,
  output reg EX_WB_write_mux_out,EX_WB_regWrite_out);always@(posedge clock,negedge reset)
  begin
    if(reset==0)
      begin
        {EX_WB_write_mux_out,EX_WB_regWrite_out} <= 2'b0;
        {ALU_WB_out,EX_WB_Rsdata_out,EX_WB_Rd_out} <= 19'b0;
      end
    else
      begin
        {EX_WB_write_mux_out,EX_WB_regWrite_out} <= {EX_WB_write_mux_in,EX_WB_regWrite_in};
        {ALU_WB_out,EX_WB_Rsdata_out,EX_WB_Rd_out} <= {ALU_out,EX_WB_Rsdata_in,EX_WB_Rd_in};
      end
  end
endmodule