module top_module(
    input clk,
    input rst,
    input [31:0] din,
    input din_en,
    output reg [31:0] dout,
    input dout_en
  );// Parameters
  parameter WIDTH = 32;
  parameter DEPTH = 512;

  // Internal signals
  reg [WIDTH-1:0] mem [0:DEPTH-1];
  reg [9:0] wr_ptr = 0;
  reg [9:0] rd_ptr = 0;
  reg [9:0] count = 0;
  wire full = (count == DEPTH);
  wire empty = (count == 0);

  // Write enable logic
  reg we;
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      we <= 0;
    end else if (din_en && ~full) begin
      we <= 1;
    end else begin
      we <= 0;
    end
  end

  // Write pointer logic
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      wr_ptr <= 0;
    end else if (we) begin
      wr_ptr <= wr_ptr + 1;
    end
  end

  // Read enable logic
  reg re;
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      re <= 0;
    end else if (dout_en && ~empty) begin
      re <= 1;
    end else begin
      re <= 0;
    end
  end

  // Read pointer logic
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      rd_ptr <= 0;
    end else if (re) begin
      rd_ptr <= rd_ptr + 1;
    end
  end

  // Count logic
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      count <= 0;
    end else begin
      count <= count + we - re;
    end
  end

  // Memory read/write logic
  always @ (posedge clk) begin
    if (we) begin
      mem[wr_ptr] <= din;
    end
    if (re) begin
      dout <= mem[rd_ptr];
    end
  end

endmodule