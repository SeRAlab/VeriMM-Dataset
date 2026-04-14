module top_module(
  input dclkin,
  input scein,
  input sdoin,
  input oe,
  output reg data0out  // Changed to reg type
);reg [31:0] mem[0:255];
  reg [7:0] addr;
  wire [31:0] data;

  assign data = mem[addr];

  always @(posedge dclkin) begin
    if (scein && oe) begin
      data0out <= data;  // This is now valid as data0out is a reg type
    end
  end

  always @(posedge dclkin) begin
    if (scein && !oe) begin
      mem[addr] <= sdoin;
    end
  end

endmodule