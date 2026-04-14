module top_module(
    output out,
    output [31:0] m_axi_wdata,
    output reg [7:0] gc0_count_d1_reg,
    input aclk,
    output s_dclk_o,
    input Q,
    input m_axi_wready,
    input [7:0] burst_count_reg,
    input tx_fifo_wr,
    input tx_fifowren_reg,
    input [31:0] tx_fifo_dataout_reg
);reg [0:0] Q_reg;
reg [31:0] m_axi_wdata_reg;
reg [7:0] burst_count_reg_reg;
reg [31:0] tx_fifo_dataout_reg_reg;
reg [0:0] out_reg;
reg [31:0] s_dclk_o_counter;

assign s_dclk_o = (s_dclk_o_counter == 0);
assign m_axi_wdata = m_axi_wdata_reg;
assign burst_count_reg = burst_count_reg_reg;
assign tx_fifo_dataout_reg = tx_fifo_dataout_reg_reg;
assign out = out_reg;

always @(posedge aclk) begin
    Q_reg <= Q;
    out_reg <= Q_reg;
    gc0_count_d1_reg <= gc0_count_d1_reg + 1; // corrected this line
end

always @(posedge aclk) begin
    if (tx_fifowren_reg) begin
        tx_fifo_dataout_reg_reg <= tx_fifo_dataout_reg;
    end
    if (tx_fifo_wr && !tx_fifowren_reg) begin
        burst_count_reg_reg <= burst_count_reg;
    end
end

always @(posedge s_dclk_o) begin
    if (m_axi_wready) begin
        m_axi_wdata_reg <= tx_fifo_dataout_reg_reg; // corrected this line
    end
end

endmodule