module top_module(
  input clk,
  input wr_en,
  input wr_rst_busy,
  input E,
  input [5:0] v1_reg,
  input [5:0] v1_reg_0,
  output reg out,
  output reg full,
  output reg [11:0] count
);reg [5:0] buffer [0:1023];
  reg [10:0] head = 0;
  reg [10:0] tail = 0;
  reg [11:0] count_reg = 0;
  
  always @(posedge clk) begin
    if (wr_rst_busy) begin
      head <= 0;
      tail <= 0;
      count_reg <= 0;
      full <= 0;
    end else begin
      if (wr_en && E) begin
        buffer[head] <= v1_reg;
        head <= (head == 1023) ? 0 : head + 1;
        count_reg <= count_reg + 1;
        if (count_reg == 1024) begin
          full <= 1;
        end
      end
      if (tail != head) begin
        out <= buffer[tail];
        tail <= (tail == 1023) ? 0 : tail + 1;
        count_reg <= count_reg - 1;
        full <= 0;
      end
    end
  end
  
  assign count = count_reg;
  
endmodule