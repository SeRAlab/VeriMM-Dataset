module top_module(

  

  input                   rx_clk,
  input       [ 3:0]      rx_ip_sof,
  input       [31:0]      rx_ip_data,
  output  reg             rx_sof,
  output  reg [31:0]      rx_data);reg     [31:0]  rx_ip_data_d = 'd0;
  reg     [ 3:0]  rx_ip_sof_hold = 'd0;
  reg     [ 3:0]  rx_ip_sof_d = 'd0;

  

  always @(posedge rx_clk) begin
    rx_ip_data_d <= rx_ip_data;
    rx_ip_sof_d <= rx_ip_sof;
    if (rx_ip_sof != 4'h0) begin
      rx_ip_sof_hold <= rx_ip_sof;
    end
    rx_sof <= |rx_ip_sof_d;
    if (rx_ip_sof_hold[0] == 1'b1) begin
      rx_data <= rx_ip_data;
    end else if (rx_ip_sof_hold[1] == 1'b1) begin
      rx_data <= {rx_ip_data[ 7:0], rx_ip_data_d[31: 8]};
    end else if (rx_ip_sof_hold[2] == 1'b1) begin
      rx_data <= {rx_ip_data[15:0], rx_ip_data_d[31:16]};
    end else if (rx_ip_sof_hold[3] == 1'b1) begin
      rx_data <= {rx_ip_data[23:0], rx_ip_data_d[31:24]};
    end else begin
      rx_data <= 32'd0;
    end
  end

endmodule