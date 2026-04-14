module top_module(
    input s_axi_aclk,
    input bus2ip_cs,
    input bus2ip_rnw,
    input [7:0] gpio_io_t,
    output reg [7:0] gpio_io_o, // Changed to reg
    output reg ip2bus_rdack_i,   // Changed to reg
    output reg ip2bus_wrack_i_D1_reg, // Changed to reg
    output reg GPIO_xferAck_i    // Changed to reg
);reg [7:0] gpio_io_o_reg;
    reg [7:0] gpio_io_t_reg;
    reg ip2bus_rdack_i_reg;
    reg ip2bus_wrack_i_D1_reg_reg;
    reg GPIO_xferAck_i_reg;
    
    always @(posedge s_axi_aclk) begin
        if (bus2ip_rnw) begin
            gpio_io_t_reg <= {8{1'b0}};
            gpio_io_o_reg <= gpio_io_o_reg;
            ip2bus_rdack_i_reg <= 1'b0;
            ip2bus_wrack_i_D1_reg_reg <= ip2bus_wrack_i_D1_reg_reg;
            GPIO_xferAck_i_reg <= 1'b0;
        end else begin
            gpio_io_t_reg <= gpio_io_t;
            gpio_io_o_reg <= gpio_io_o;
            ip2bus_rdack_i_reg <= ip2bus_rdack_i_reg;
            ip2bus_wrack_i_D1_reg_reg <= ip2bus_wrack_i_D1_reg;
            GPIO_xferAck_i_reg <= 1'b1;
        end
    end
    
    always @(bus2ip_cs or ip2bus_rdack_i_reg or ip2bus_wrack_i_D1_reg_reg or GPIO_xferAck_i_reg) begin
        if (!bus2ip_cs) begin
            ip2bus_rdack_i <= 1'b0;
            ip2bus_wrack_i_D1_reg <= 1'b0;
            GPIO_xferAck_i <= 1'b0;
        end else begin
            ip2bus_rdack_i <= ip2bus_rdack_i_reg;
            ip2bus_wrack_i_D1_reg <= ip2bus_wrack_i_D1_reg_reg;
            GPIO_xferAck_i <= GPIO_xferAck_i_reg;
        end
    end
    
    assign gpio_io_o = gpio_io_o_reg;
    
endmodule