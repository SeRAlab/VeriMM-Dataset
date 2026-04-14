module top_module(
  input clk,
  input rst,
  input [31:0] axi_araddr,
  input axi_arvalid,
  output axi_arready,
  output [31:0] axi_rdata,
  output axi_rvalid,
  input axi_rready
);localparam MEM_SIZE = 1024;
  reg [31:0] mem [0:MEM_SIZE-1];
  reg [31:0] rdata;

  assign axi_arready = 1'b1;

  always @ (posedge clk) begin
    if (rst) begin
      rdata <= 0;
    end else if (axi_arvalid && axi_rready) begin
      rdata <= mem[axi_araddr[9:2]];
    end
  end

  assign axi_rvalid = axi_arvalid && axi_rready;
  assign axi_rdata = rdata;

endmodule