module top_module(D,
    Q,
    wr_clk,
    wr_rst_reg_reg);output reg [7:0] Q;  // Changed to 'reg' since Q is driven inside an always block
  input [7:0] D;
  input wr_clk;
  input [0:0] wr_rst_reg_reg;

  reg [7:0] buffer [0:8191];
  reg [12:0] head = 0;
  reg [12:0] tail = 0;
  reg [12:0] count = 0;

  always @(posedge wr_clk) begin
    if (wr_rst_reg_reg == 1'b1) begin
      head <= 0;
      tail <= 0;
      count <= 0;
    end else if (count < 8192 && wr_rst_reg_reg == 1'b0) begin
      buffer[head] <= D;
      head <= (head == 8191) ? 0 : head + 1;
      count <= count + 1;
    end
  end

  always @(posedge wr_clk) begin
    if (wr_rst_reg_reg == 1'b1) begin
      head <= 0;
      tail <= 0;
      count <= 0;
    end else if (count > 0 && wr_rst_reg_reg == 1'b0) begin
      Q <= buffer[tail];
      tail <= (tail == 8191) ? 0 : tail + 1;
      count <= count - 1;
    end
  end

endmodule