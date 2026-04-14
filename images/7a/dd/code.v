module top_module(dout,
    empty,
    full,
    rd_en,
    clk,
    din,
    rst,
    wr_en);output reg [93:0] dout;  // Change to reg for dout since it's assigned in an always block
  output empty;
  output full;
  input rd_en;
  input clk;
  input [93:0] din;
  input rst;
  input wr_en;

  reg [93:0] mem [63:0];
  reg [5:0] head;
  reg [5:0] tail;
  reg [5:0] count;  // Change count to reg to allow assignment in always block

  assign empty = (count == 0);
  assign full = (count == 64);

  always @(posedge clk) begin
    if (rst) begin
      head <= 0;
      tail <= 0;
      count <= 0;
      dout <= 0;  // Reset dout on reset
    end else begin
      if (wr_en && !full) begin
        mem[head] <= din;
        head <= head + 1;
        count <= count + 1;
      end
      if (rd_en && !empty) begin
        dout <= mem[tail];
        tail <= tail + 1;
        count <= count - 1;
      end
    end
  end

endmodule