module top_module(
  input clk,
  input rst,
  input [7:0] data_in,
  output reg [31:0] checksum_out,
  output reg error
);reg [15:0] s1;
  reg [15:0] s2;

  always @(posedge clk) begin
    if (rst) begin
      s1 <= 16'h1;
      s2 <= 16'h1;
      checksum_out <= 32'h0;
      error <= 1'b0;
    end else begin
      s1 <= (s1 + data_in) % 16'hFFFF;
      s2 <= (s2 + s1) % 16'hFFFF;
      if (s2 == 16'hFFFF) begin
        checksum_out <= (s2 << 16) | s1;
      end
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      error <= 1'b0;
    end else begin
      if (checksum_out != ((s2 << 16) | s1)) begin
        error <= 1'b1;
      end else begin
        error <= 1'b0;
      end
    end
  end

endmodule