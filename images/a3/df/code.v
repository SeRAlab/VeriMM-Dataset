module top_module(
    input clk,
    input rst_x,
    input i_irq_x,
    input i_nmi_x,
    output reg [7:0] w_mc2il_data,
    output reg [15:0] w_il2mc_addr,
    output reg w_il2mc_read,
    output reg [7:0] w_il2rf_data,
    output reg w_il2rf_set_pcl,
    output reg w_il2rf_set_pch,
    output reg w_il2rf_pushed
);reg irq_latched;
reg nmi_latched;

always @(posedge clk) begin
    if (rst_x == 1'b0) begin
        irq_latched <= 1'b0;
        nmi_latched <= 1'b0;
        w_il2mc_read <= 1'b0;
        w_il2rf_set_pcl <= 1'b0;
        w_il2rf_set_pch <= 1'b0;
        w_il2rf_pushed <= 1'b0;
    end else begin
        if (i_irq_x == 1'b0 && irq_latched == 1'b0) begin
            w_mc2il_data <= 8'h00;
            w_il2mc_addr <= 16'hfffe;
            w_il2mc_read <= 1'b1;
            w_il2rf_set_pcl <= 1'b1;
            irq_latched <= 1'b1;
        end else if (i_nmi_x == 1'b0 && nmi_latched == 1'b0) begin
            w_mc2il_data <= 8'h00;
            w_il2mc_addr <= 16'hfffa;
            w_il2mc_read <= 1'b1;
            w_il2rf_set_pcl <= 1'b1;
            nmi_latched <= 1'b1;
        end else begin
            w_il2mc_read <= 1'b0;
            w_il2rf_set_pcl <= 1'b0;
            w_il2rf_set_pch <= 1'b0;
            w_il2rf_pushed <= 1'b0;
        end
    end
end

endmodule