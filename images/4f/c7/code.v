module top_module(
  input                clk,
  input                reset,
  input [15:0]         wr_data,
  input                wr_en,
  input                rd_en,
  output reg [15:0]    rd_data,
  output reg           rd_empty,
  output reg           wr_full
);reg [4:0]            wr_addr;
  reg [4:0]            rd_addr;
  reg [4:0]            count;

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      wr_addr <= 5'b0;
      rd_addr <= 5'b0;
      count <= 5'b0;
      rd_empty <= 1'b1;
      wr_full <= 1'b0;
    end else begin
      if (wr_en && rd_en) begin
        // If both write and read are enabled, no operation
      end else if (wr_en) begin
        mem[wr_addr] <= wr_data; // Write data to memory
        wr_addr <= wr_addr + 1;
        count <= count + 1;
        rd_empty <= 1'b0;
        if (count == 5'b11111)
          wr_full <= 1'b1;
      end else if (rd_en) begin
        rd_data <= mem[rd_addr]; // Read data from memory
        rd_addr <= rd_addr + 1;
        count <= count - 1;
        wr_full <= 1'b0;
        if (count == 5'b0)
          rd_empty <= 1'b1;
      end
    end
  end

  reg [15:0] mem [31:0];

  always @ (posedge clk) begin
    if (wr_en && !wr_full) // Only write if not full
      mem[wr_addr] <= wr_data;
  end

endmodule