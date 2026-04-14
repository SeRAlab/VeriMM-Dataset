module top_module(out,
    S_AXI_RDATA,
    S_AXI_AWREADY,
    S_AXI_ARREADY,
    S_AXI_BVALID,
    S_AXI_RVALID,
    S_AXI_ACLK,
    S_AXI_WDATA,
    S_AXI_ARADDR,
    S_AXI_AWADDR,
    S_AXI_AWVALID,
    S_AXI_WVALID,
    S_AXI_ARESETN,
    S_AXI_BREADY,
    S_AXI_RREADY,
    S_AXI_ARVALID);// Added S_AXI_ARVALID to port list

  output [1:0] out;
  output [31:0] S_AXI_RDATA;
  output S_AXI_AWREADY;
  output S_AXI_ARREADY;
  output S_AXI_BVALID;
  output S_AXI_RVALID;
  input S_AXI_ACLK;
  input [31:0] S_AXI_WDATA;
  input [2:0] S_AXI_ARADDR;
  input [2:0] S_AXI_AWADDR;
  input S_AXI_AWVALID;
  input S_AXI_WVALID;
  input S_AXI_ARESETN;
  input S_AXI_BREADY;
  input S_AXI_RREADY;
  input S_AXI_ARVALID; // Declaration for S_AXI_ARVALID

  reg [1:0] out_reg;
  reg [31:0] S_AXI_RDATA_reg;
  reg S_AXI_AWREADY_reg;
  reg S_AXI_ARREADY_reg;
  reg S_AXI_BVALID_reg;
  reg S_AXI_RVALID_reg;

  always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
      out_reg <= 2'b00;
      S_AXI_RDATA_reg <= 32'h00000000;
      S_AXI_AWREADY_reg <= 1'b0;
      S_AXI_ARREADY_reg <= 1'b0;
      S_AXI_BVALID_reg <= 1'b0;
      S_AXI_RVALID_reg <= 1'b0;
    end else begin
      if (S_AXI_ARVALID && !S_AXI_RVALID_reg) begin
        out_reg <= 2'b01;
        S_AXI_RDATA_reg <= 32'h00000001;
        S_AXI_ARREADY_reg <= 1'b1;
        S_AXI_RVALID_reg <= 1'b1;
      end else if (S_AXI_AWVALID && !S_AXI_BVALID_reg) begin
        out_reg <= 2'b10;
        S_AXI_AWREADY_reg <= 1'b1;
        S_AXI_BVALID_reg <= 1'b1;
      end else begin
        out_reg <= 2'b00;
        S_AXI_AWREADY_reg <= 1'b0;
        S_AXI_ARREADY_reg <= 1'b0;
        S_AXI_BVALID_reg <= 1'b0;
        S_AXI_RVALID_reg <= 1'b0;
      end
    end
  end

  assign out = out_reg;
  assign S_AXI_RDATA = S_AXI_RDATA_reg;
  assign S_AXI_AWREADY = S_AXI_AWREADY_reg;
  assign S_AXI_ARREADY = S_AXI_ARREADY_reg;
  assign S_AXI_BVALID = S_AXI_BVALID_reg;
  assign S_AXI_RVALID = S_AXI_RVALID_reg;
endmodule