module top_module(
  input clk, test_mode, rx_access, rx_burst,
  input [103:0] rx_packet,
  output reg erx_access,
  output reg [103:0] erx_packet
);parameter ID = 12'h999;
  
  reg [31:0] addr_reg;
  wire [31:0] next_addr;
  wire [31:0] mux_addr;
  
  assign mux_addr = rx_burst ? next_addr : addr_reg + 8;
  assign next_addr = addr_reg + 8;
  
  always @(posedge clk) begin
    if (rx_access && !test_mode) begin
      erx_access <= 1;
      erx_packet[103:40] <= rx_packet[103:40];
      erx_packet[39:8] <= mux_addr;
      erx_packet[7:0] <= 8'b00000001;
    end else begin
      erx_access <= 0;
      erx_packet <= {rx_packet[103:40], mux_addr, 8'b00000001};
    end
    
    addr_reg <= mux_addr;
  end

endmodule