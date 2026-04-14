module top_module(
  rst,
  wr_clk,
  rd_clk,
  din,
  wr_en,
  rd_en,
  dout,
  full,
  empty,
  rd_data_count,
  wr_data_count
);input rst;
input wr_clk;
input rd_clk;
input [31 : 0] din;
input wr_en;
input rd_en;
output reg [255 : 0] dout; // Change to reg since dout is assigned in always block
output reg full;           // Change to reg since full is assigned in always block
output reg empty;          // Change to reg since empty is assigned in always block
output reg [9 : 0] rd_data_count;   // Change to reg since rd_data_count is assigned in always block
output reg [12 : 0] wr_data_count;  // Change to reg since wr_data_count is assigned in always block

reg [31:0] fifo[0:255];
reg [9:0] rd_count;
reg [12:0] wr_count;
reg full_flag;
reg empty_flag;

// Write operation
always @(posedge wr_clk) begin
  if (rst) begin
    wr_count <= 0;
    full_flag <= 0;
    empty_flag <= 1;
  end else if (wr_en && !full_flag) begin
    fifo[wr_count] <= din;
    wr_count <= wr_count + 1;
    if (wr_count == 255) begin
      full_flag <= 1;
    end
    empty_flag <= 0;
  end
end

// Read operation
always @(posedge rd_clk) begin
  if (rst) begin
    rd_count <= 0;
    full_flag <= 0;
    empty_flag <= 1;
  end else if (rd_en && !empty_flag) begin
    dout <= fifo[rd_count]; // dout is assigned a value here
    rd_count <= rd_count + 1;
    if (rd_count == 255) begin
      empty_flag <= 1;
    end
    full_flag <= 0;
  end
end

// Counters and flags
always @(posedge wr_clk or posedge rst) begin
  if (rst) begin
    rd_count <= 0;
    wr_count <= 0;
    full_flag <= 0;
    empty_flag <= 1;
  end else begin
    rd_data_count <= rd_count; // rd_data_count is assigned a value here
    wr_data_count <= wr_count; // wr_data_count is assigned a value here
    full <= full_flag; // full is assigned a value here
    empty <= empty_flag; // empty is assigned a value here
  end
end

endmodule