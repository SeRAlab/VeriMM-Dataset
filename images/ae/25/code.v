module top_module(
  input IPCORE_CLK,
  input IPCORE_RESETN,
  input AXI4_Lite_ACLK,
  input AXI4_Lite_ARESETN,
  input [15:0]AXI4_Lite_AWADDR,
  input AXI4_Lite_AWVALID,
  input [31:0]AXI4_Lite_WDATA,
  input [3:0]AXI4_Lite_WSTRB,
  input AXI4_Lite_WVALID,
  input AXI4_Lite_BREADY,
  input [15:0]AXI4_Lite_ARADDR,
  input AXI4_Lite_ARVALID,
  input AXI4_Lite_RREADY,
  output AXI4_Lite_AWREADY,
  output AXI4_Lite_WREADY,
  output [1:0]AXI4_Lite_BRESP,
  output AXI4_Lite_BVALID,
  output AXI4_Lite_ARREADY,
  output [31:0]AXI4_Lite_RDATA,
  output [1:0]AXI4_Lite_RRESP,
  output AXI4_Lite_RVALID
);// AXI4-Lite write address passthrough
  assign AXI4_Lite_AWREADY = AXI4_Lite_AWVALID;
  
  // AXI4-Lite write data passthrough
  assign AXI4_Lite_WREADY = AXI4_Lite_WVALID;
  
  // AXI4-Lite write response fixed to OKAY
  assign AXI4_Lite_BRESP = 2'b00;
  assign AXI4_Lite_BVALID = AXI4_Lite_WVALID & AXI4_Lite_BREADY;
  
  // AXI4-Lite read address passthrough
  assign AXI4_Lite_ARREADY = AXI4_Lite_ARVALID;
  
  // AXI4-Lite read data passthrough
  assign AXI4_Lite_RDATA = 32'h00000000;
  assign AXI4_Lite_RRESP = 2'b00;
  assign AXI4_Lite_RVALID = AXI4_Lite_RREADY;
  
endmodule