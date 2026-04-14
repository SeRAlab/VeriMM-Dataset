module top_module(
  input clk,
  input srst,
  input [15 : 0] din,
  input wr_en,
  input rd_en,
  output reg [15 : 0] dout,  // Changed output to reg
  output full,
  output empty,
  output prog_full
);reg [15:0] mem [511:0];
  reg [8:0] wr_ptr;
  reg [8:0] rd_ptr;
  reg [8:0] count;
  reg almost_full;
  reg [31:0] prog_full_cnt;

  assign full = (count == 512);
  assign empty = (count == 0);
  assign prog_full = almost_full;

  always @(posedge clk) begin
    if (srst) begin
      wr_ptr <= 9'd0;
      rd_ptr <= 9'd0;
      count <= 9'd0;
      almost_full <= 1'b0;
      prog_full_cnt <= 32'd0;
      dout <= 16'd0;  // Initialize dout on reset
    end
    else begin
      if (wr_en && !full) begin
        mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
        count <= count + 1;
        if (count >= 504) begin
          almost_full <= 1'b1;
        end
      end
      if (rd_en && !empty) begin
        dout <= mem[rd_ptr];  // Assigning to dout
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
        almost_full <= 1'b0;
      end
      if (prog_full_cnt >= 1000000) begin
        if (count >= 504) begin
          almost_full <= 1'b1;
        end
        else begin
          almost_full <= 1'b0;
        end
        prog_full_cnt <= 32'd0;
      end
      else begin
        prog_full_cnt <= prog_full_cnt + 1;
      end
    end
  end

endmodule