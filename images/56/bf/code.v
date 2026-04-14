module reg_file_8bit(
  input clk,
  input we,
  input [3:0] waddr,
  input [7:0] wdata,
  input [3:0] raddr1,
  input [3:0] raddr2,
  output [7:0] rdata1,
  output [7:0] rdata2
);

  reg [7:0] regfile [0:15];

  always @(posedge clk) begin
    if (we)
      regfile[waddr] <= wdata;
  end

  assign rdata1 = regfile[raddr1];
  assign rdata2 = regfile[raddr2];

endmodule