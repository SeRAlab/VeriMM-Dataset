module top_module(
  input s_axi_aclk,
  input s_axi_aresetn,
  input [8:0]s_axi_awaddr,
  input s_axi_awvalid,
  output reg s_axi_awready,  // Changed to reg
  input [31:0]s_axi_wdata,
  input [3:0]s_axi_wstrb,
  input s_axi_wvalid,
  output reg s_axi_wready,    // Changed to reg
  output reg [1:0]s_axi_bresp, // Changed to reg
  output reg s_axi_bvalid,     // Changed to reg
  input s_axi_bready,
  input [8:0]s_axi_araddr,
  input s_axi_arvalid,
  output reg s_axi_arready,    // Changed to reg
  output reg [31:0]s_axi_rdata, // Changed to reg
  output reg [1:0]s_axi_rresp,  // Changed to reg
  output reg s_axi_rvalid,      // Changed to reg
  input s_axi_rready,
  output ip2intc_irpt,
  inout [19:0]gpio_io_i,
  inout [19:0]gpio_io_o,
  inout [19:0]gpio_io_t
);reg [19:0] gpio_input_reg;
  reg [19:0] gpio_output_reg;

  assign gpio_io_i = gpio_input_reg;
  assign gpio_io_o = gpio_output_reg;
  assign gpio_io_t = 20'hFFFFF;

  always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
      gpio_input_reg <= 20'h0;
      gpio_output_reg <= 20'h0;
      s_axi_awready <= 1'b0; // Added reset logic
      s_axi_wready <= 1'b0;  // Added reset logic
      s_axi_bvalid <= 1'b0;  // Added reset logic
      s_axi_arready <= 1'b0;  // Added reset logic
      s_axi_rvalid <= 1'b0;   // Added reset logic
    end else begin
      s_axi_awready <= 1'b1;
      s_axi_wready <= 1'b1;
      s_axi_arready <= 1'b1;

      if (s_axi_arvalid && s_axi_arready) begin
        case (s_axi_araddr)
          8'h00: s_axi_rdata <= gpio_input_reg; // Valid assignment
          default: s_axi_rdata <= 32'h0;         // Valid assignment
        endcase
        s_axi_rvalid <= 1'b1;                    // Set to valid when read operation happens
      end else begin
        s_axi_rvalid <= 1'b0;                    // Reset valid
      end

      if (s_axi_awvalid && s_axi_awready) begin
        case (s_axi_awaddr)
          8'h00: gpio_output_reg <= s_axi_wdata & s_axi_wstrb; // Masking behavior
          default: ;
        endcase
        s_axi_bvalid <= 1'b1;                     // Set valid after write operation
      end else if (s_axi_bready) begin
        s_axi_bvalid <= 1'b0;                      // Reset valid
      end
    end
  end

  assign s_axi_bresp = 2'b00; // Assume OK response
  assign s_axi_rresp = 2'b00; // Assume OK response
  assign ip2intc_irpt = 1'b0;

endmodule