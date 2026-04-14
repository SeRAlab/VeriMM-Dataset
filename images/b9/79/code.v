module top_module(
    input s_axi_aclk,
    input bus2ip_rnw_i_reg,
    input [3:0] gpio_io_i,
    input [3:0] MEM_DECODE_GEN_0_cs_out_i_reg_0,
    output [3:0] D,
    output [3:0] gpio_io_o,
    output [3:0] gpio_io_t,
    output [3:0] Q,
    output GPIO_xferAck_i,
    output gpio_xferAck_Reg,
    output ip2bus_rdack_i,
    output ip2bus_wrack_i_D1_reg,
    output bus2ip_rnw,
    output bus2ip_cs
);reg [3:0] gpio_io_i_reg;
reg [3:0] MEM_DECODE_GEN_0_cs_out_i_reg_0_reg;

assign gpio_io_o = gpio_io_i_reg;
assign gpio_io_t = MEM_DECODE_GEN_0_cs_out_i_reg_0_reg;
assign Q = gpio_io_i_reg;
assign D = MEM_DECODE_GEN_0_cs_out_i_reg_0_reg;

reg GPIO_xferAck_i_reg;
reg gpio_xferAck_Reg_reg;
reg ip2bus_rdack_i_reg;
reg ip2bus_wrack_i_D1_reg_reg;
reg bus2ip_rnw_reg;
reg bus2ip_cs_reg;

always @(posedge s_axi_aclk) begin
    gpio_io_i_reg <= gpio_io_i;
    MEM_DECODE_GEN_0_cs_out_i_reg_0_reg <= MEM_DECODE_GEN_0_cs_out_i_reg_0;
    
    GPIO_xferAck_i_reg <= 1'b0;
    gpio_xferAck_Reg_reg <= GPIO_xferAck_i_reg;
    ip2bus_rdack_i_reg <= 1'b0;
    ip2bus_wrack_i_D1_reg_reg <= 1'b0;
    bus2ip_rnw_reg <= bus2ip_rnw_i_reg;
    bus2ip_cs_reg <= 1'b1;
end

assign GPIO_xferAck_i = GPIO_xferAck_i_reg;
assign gpio_xferAck_Reg = gpio_xferAck_Reg_reg;
assign ip2bus_rdack_i = ip2bus_rdack_i_reg;
assign ip2bus_wrack_i_D1_reg = ip2bus_wrack_i_D1_reg_reg;
assign bus2ip_rnw = bus2ip_rnw_reg;
assign bus2ip_cs = bus2ip_cs_reg;

endmodule