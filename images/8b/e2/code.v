module top_module(
  input clk,
  input rstn,
  input loaden,
  input unloaden,
  input [63:0] datain,
  output reg [63:0] dataout,
  output reg empty,
  output reg full,
  output reg [5:0] itemsinfifo
);parameter WIDTH = 64;
  parameter DEPTH = 6;

  reg [WIDTH-1:0] memory [0:DEPTH-1];
  reg [5:0] head;
  reg [5:0] tail;
  reg [5:0] count;

  assign empty = (count == 0);
  assign full = (count == DEPTH);

  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      head <= 0;
      tail <= 0;
      count <= 0;
    end else begin
      if (loaden && ~full) begin
        memory[head] <= datain;
        head <= head + 1;
        count <= count + 1;
      end
      if (unloaden && ~empty) begin
        dataout <= memory[tail];
        tail <= tail + 1;
        count <= count - 1;
      end
    end
  end

  always @(count) begin
    itemsinfifo <= count;
  end

endmodule