module top_module(
    input [15:0]  m_alu_result,
    input [15:0]  m_dm_dout,
    input [2:0]   m_reg_waddr,
    input         cu_reg_data_loc,
    input         cu_reg_load,
    output [15:0] wb_reg_wdata,
    output        wb_reg_wea,
    output [2:0]  wb_reg_waddr
);assign wb_reg_wdata = cu_reg_data_loc ? m_dm_dout : m_alu_result;

assign wb_reg_wea = cu_reg_load;
assign wb_reg_waddr = m_reg_waddr;

endmodule