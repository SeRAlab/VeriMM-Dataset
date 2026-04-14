module top_module(
    input s_axi_aclk,
    input ext_spi_clk,
    input rx_fifo_reset,
    input [27:0] ce_out_i_reg,
    input ip2Bus_RdAck_core_reg_reg,
    input Bus_RNW_reg,
    input [7:0] p_5_in,
    input rx_fifo_empty_i_reg,
    input spiXfer_done_int,
    input scndry_out,
    input [0:0] E,
    input [7:0] Q,
    output reg [7:0] out,
    output reg Rx_FIFO_Full_Fifo_d1_reg,
    output reg ram_full_fb_i_reg,
    output reg [3:0] icount_out_reg,
    output reg Receive_ip2bus_error0,
    output reg Rx_FIFO_Full_Fifo,
    output reg [24:0] IP2Bus_Data_reg
    );// detect when FIFO is full
    always @(posedge s_axi_aclk) begin
        Rx_FIFO_Full_Fifo_d1_reg <= rx_fifo_empty_i_reg;
        if (rx_fifo_empty_i_reg == 1'b0) begin
            Rx_FIFO_Full_Fifo <= 1'b1;
        end else if (ip2Bus_RdAck_core_reg_reg == 1'b1 && Bus_RNW_reg == 1'b0) begin
            Rx_FIFO_Full_Fifo <= 1'b0;
        end
    end

    // detect when FIFO is empty
    always @(posedge s_axi_aclk) begin
        if (rx_fifo_empty_i_reg == 1'b1) begin
            icount_out_reg <= 4'b0000;
        end else if (ip2Bus_RdAck_core_reg_reg == 1'b1 && Bus_RNW_reg == 1'b1) begin
            icount_out_reg <= icount_out_reg + 1;
        end
    end

    // handle errors
    always @(posedge s_axi_aclk) begin
        if (ip2Bus_RdAck_core_reg_reg == 1'b0 && Bus_RNW_reg == 1'b1) begin
            Receive_ip2bus_error0 <= 1'b1;
        end else begin
            Receive_ip2bus_error0 <= 1'b0;
        end
    end

    // interface with Quad SPI Shield
    always @(posedge ext_spi_clk) begin
        if (E == 1'b1) begin
            out <= Q;
        end
    end

    // interface with FIFO generator
    always @(posedge s_axi_aclk) begin
        IP2Bus_Data_reg <= p_5_in;
        ram_full_fb_i_reg <= Rx_FIFO_Full_Fifo;
    end

endmodule