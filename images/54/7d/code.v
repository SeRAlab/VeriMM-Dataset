module top_module(
  input wire s_axi_aclk,
  input wire s_axi_aresetn,
  input wire fifo_wr,
  input wire tx_Start,
  input wire tx_Data_Enable_reg,
  input wire [7:0] tx_DataBits,
  input wire [7:0] s_axi_wdata,
  input wire p_4_in,
  input wire fifo_Read,
  input wire reset_TX_FIFO_reg,
  input wire mux_sel_reg_0,
  input wire mux_sel_reg_2,
  output wire tx_Buffer_Full,
  output wire mux_Out,
  output reg [7:0] Q,  // Changed from output wire to output reg
  output wire tx_Start0
);reg [3:0] write_ptr;
  reg [3:0] read_ptr;
  reg [7:0] fifo [15:0];
  reg tx_Buffer_Full_reg; // Renamed to avoid conflict

  always @(posedge s_axi_aclk) begin
    if (~s_axi_aresetn) begin
      write_ptr <= 0;
      read_ptr <= 0;
      tx_Buffer_Full_reg <= 0;
    end else begin
      if (fifo_wr && !tx_Buffer_Full_reg) begin
        fifo[write_ptr] <= s_axi_wdata;
        write_ptr <= write_ptr + 1;
        if (write_ptr == 15) begin
          write_ptr <= 0;
        end
        if (write_ptr == read_ptr) begin
          tx_Buffer_Full_reg <= 1;
        end
      end
      if (fifo_Read) begin
        Q <= fifo[read_ptr];
        read_ptr <= read_ptr + 1;
        if (read_ptr == 15) begin
          read_ptr <= 0;
        end
        tx_Buffer_Full_reg <= 0;
      end
    end
  end

  assign mux_Out = mux_sel_reg_0 ? tx_DataBits : p_4_in;
  assign tx_Start0 = tx_Start && tx_Data_Enable_reg;
  assign tx_Buffer_Full = tx_Buffer_Full_reg; // Assigning reg to wire

endmodule