module top_module(
  RST_N,
  CLK,
  BUS_WE,
  BUS_ADDR,
  BUS_WDATA,
  BUS_RDATA,
  EXPIRED
);parameter BUS_ADDR_WIDTH = 4;
parameter BUS_DATA_WIDTH = 32;

input wire RST_N;
input wire CLK;
input wire BUS_WE;
input wire [BUS_ADDR_WIDTH-1:0] BUS_ADDR;
input wire [BUS_DATA_WIDTH-1:0] BUS_WDATA;
output reg [BUS_DATA_WIDTH-1:0] BUS_RDATA;
output reg EXPIRED;

reg [31:0] count;
reg [31:0] target;

always @(posedge CLK) begin
  if (!RST_N) begin
    count <= 0;
  end else if (count == target) begin
    EXPIRED <= 1;
  end else begin
    count <= count + 1;
    EXPIRED <= 0;
  end
end

always @(posedge CLK) begin
  if (BUS_WE && (BUS_ADDR == 4)) begin
    target <= BUS_WDATA;
  end
end

always @(*) begin
  BUS_RDATA = target;
end

endmodule