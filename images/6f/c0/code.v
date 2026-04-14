module top_module(
  input clk,
  input reset_n,
  input wr,
  input [31:0] wr_data,
  input rd,
  output [31:0] rd_data,
  output empty,
  output full
);reg [31:0] buffer [1:0];
  reg [1:0] wr_ptr = 2'b00;
  reg [1:0] rd_ptr = 2'b00;
  reg [1:0] next_wr_ptr;
  reg [1:0] next_rd_ptr;
  reg full_reg;
  reg empty_reg;

  assign empty = empty_reg;
  assign full = full_reg;
  assign rd_data = buffer[rd_ptr];

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      wr_ptr <= 2'b00;
      rd_ptr <= 2'b00;
      full_reg <= 1'b0;
      empty_reg <= 1'b1;
    end else begin
      next_wr_ptr = wr_ptr + 2'b01;
      next_rd_ptr = rd_ptr + 2'b01;
      if (wr & !full_reg) begin
        buffer[wr_ptr] <= wr_data;
        wr_ptr <= next_wr_ptr;
        if (next_wr_ptr == rd_ptr) begin
          full_reg <= 1'b1;
        end
        empty_reg <= 1'b0;
      end else if (rd & !empty_reg) begin
        rd_ptr <= next_rd_ptr;
        if (next_rd_ptr == wr_ptr) begin
          empty_reg <= 1'b1;
        end
        full_reg <= 1'b0;
      end
    end
  end

endmodule