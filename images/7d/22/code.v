module top_module(
  input s_axi_aclk,
  input s_axi_aresetn,
  input [8:0]s_axi_awaddr,
  input s_axi_awvalid,
  output s_axi_awready,
  input [31:0]s_axi_wdata,
  input [3:0]s_axi_wstrb,
  input s_axi_wvalid,
  output s_axi_wready,
  output [1:0]s_axi_bresp,
  output s_axi_bvalid,
  input s_axi_bready,
  input [8:0]s_axi_araddr,
  input s_axi_arvalid,
  output s_axi_arready,
  output reg [31:0]s_axi_rdata, // Changed to reg
  output [1:0]s_axi_rresp,
  output s_axi_rvalid,
  input s_axi_rready,
  input [1:0]gpio_io_i,
  output [1:0]gpio_io_o,
  output [1:0]gpio_io_t
);reg [1:0] gpio_out_reg;
  wire [1:0] gpio_out;
  assign gpio_out = gpio_io_t ? 2'bzz : gpio_out_reg;

  always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
      gpio_out_reg <= 2'b00;
      s_axi_rdata <= 32'b0; // Ensure proper initialization of s_axi_rdata
    end else begin
      if (s_axi_awvalid && s_axi_awready) begin
        case (s_axi_awaddr)
          9'd0: gpio_out_reg[0] <= s_axi_wdata[1:0];
          9'd1: gpio_out_reg[1] <= s_axi_wdata[1:0];
        endcase
      end

      if (s_axi_arvalid && s_axi_arready) begin
        case (s_axi_araddr)
          9'd0: s_axi_rdata <= {30'b0, gpio_out_reg[0]};
          9'd1: s_axi_rdata <= {30'b0, gpio_out_reg[1]};
        endcase
      end
    end
  end

  assign s_axi_awready = 1;
  assign s_axi_wready = 1;
  assign s_axi_bresp = 2'b00;
  assign s_axi_bvalid = 0;
  assign s_axi_arready = 1;
  assign s_axi_rresp = 2'b00;
  assign s_axi_rvalid = (s_axi_arvalid && s_axi_arready);

  assign gpio_io_o = gpio_out;

endmodule