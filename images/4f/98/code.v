module top_module(clk, srst, din, wr_en, rd_en, dout, full, empty);input clk;
  input srst;
  input [63:0] din;
  input wr_en;
  input rd_en;
  output reg [63:0] dout; // Change output to reg
  output full;
  output empty;

  reg [63:0] buffer [0:15];
  reg [3:0] head = 0;
  reg [3:0] tail = 0;
  reg [3:0] count = 0;

  always @(posedge clk) begin
    if (srst) begin
      head <= 0;
      tail <= 0;
      count <= 0;
      dout <= 0; // Initialize dout on reset
    end else begin
      if (wr_en && !full) begin
        buffer[head] <= din;
        head <= head + 1;
        count <= count + 1;
      end
      if (rd_en && !empty) begin
        dout <= buffer[tail];
        tail <= tail + 1;
        count <= count - 1;
      end
    end
  end

  assign full = (count == 16);
  assign empty = (count == 0);

endmodule