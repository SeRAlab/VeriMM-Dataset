module top_module(
  input clk,
  input reset,
  input write_en,
  input [word_size-1:0] data_in,
  output read_en,
  output [word_size-1:0] data_out,
  output full,
  output empty
);parameter depth = 16; // depth of the FIFO
parameter word_size = 8; // size of each data word

reg [word_size-1:0] memory [depth-1:0];
reg [word_size-1:0] data_out_reg;
reg full_reg;
reg empty_reg;
reg [4:0] count_reg;

integer i;

always @(posedge clk) begin
  if (reset) begin
    for (i = 0; i < depth; i = i + 1) begin
      memory[i] <= 0;
    end
    count_reg <= 0;
    full_reg <= 0;
    empty_reg <= 1;
    data_out_reg <= 0;
  end else begin
    if (write_en && !full_reg) begin
      memory[count_reg] <= data_in;
      count_reg <= count_reg + 1;
      if (count_reg == depth) begin
        full_reg <= 1;
      end
      if (count_reg != 0) begin
        empty_reg <= 0;
      end
    end
    if (read_en && !empty_reg) begin
      data_out_reg <= memory[0];
      for (i = 0; i < depth-1; i = i + 1) begin
        memory[i] <= memory[i+1];
      end
      memory[depth-1] <= 0;
      count_reg <= count_reg - 1;
      if (count_reg == 0) begin
        empty_reg <= 1;
      end
      if (count_reg != depth) begin
        full_reg <= 0;
      end
    end
  end
end

assign data_out = data_out_reg;
assign full = full_reg;
assign empty = empty_reg;
assign read_en = !empty_reg;

endmodule