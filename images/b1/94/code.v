module top_module(
  input clk,
  input rst,
  input en,
  input wr,
  input rd,
  input [9:0] addr,
  input [7:0] data_in,
  output reg [7:0] data_out
);reg [7:0] ram [0:1023];

always @(posedge clk) begin
  if (rst) begin
    data_out <= 8'b0;
  end else begin
    if (en) begin
      if (wr) begin
        ram[addr] <= data_in;
      end
      if (rd) begin
        data_out <= ram[addr];
      end
    end
  end
end

endmodule