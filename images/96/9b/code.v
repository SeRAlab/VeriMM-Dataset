module top_module(
  input wire s_axis_aresetn,
  input wire s_axis_aclk,
  input wire s_axis_tvalid,
  input wire [39:0] s_axis_tdata,
  output wire s_axis_tready,
  output wire m_axis_tvalid,
  output wire [39:0] m_axis_tdata,
  output wire [31:0] axis_data_count,
  output wire [31:0] axis_wr_data_count,
  output wire [31:0] axis_rd_data_count,
  input wire m_axis_tready // Added this missing input
);// Parameter definitions
  parameter DATA_WIDTH = 40;
  parameter ADDR_WIDTH = 10;
  parameter DEPTH = 1024;

  // Internal signals
  reg [DATA_WIDTH-1:0] fifo [DEPTH-1:0];
  reg [ADDR_WIDTH-1:0] wr_ptr = 0;
  reg [ADDR_WIDTH-1:0] rd_ptr = 0;
  reg [31:0] data_count = 0;
  reg [31:0] wr_data_count = 0;
  reg [31:0] rd_data_count = 0;
  wire full = (data_count == DEPTH);
  wire empty = (data_count == 0);

  // Read/Write pointers
  always @(posedge s_axis_aclk) begin
    if (!s_axis_aresetn) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      data_count <= 0;
      wr_data_count <= 0;
      rd_data_count <= 0;
    end else begin
      if (s_axis_tvalid && s_axis_tready) begin
        fifo[wr_ptr] <= s_axis_tdata;
        wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1;
        data_count <= data_count + 1;
        wr_data_count <= wr_data_count + 1;
      end
      if (m_axis_tvalid && m_axis_tready) begin
        rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1;
        data_count <= data_count - 1;
        rd_data_count <= rd_data_count + 1;
      end
    end
  end

  // Data output
  assign m_axis_tdata = fifo[rd_ptr];
  assign m_axis_tvalid = (data_count > 0);
  assign s_axis_tready = (!full);

  // Output signals
  assign axis_data_count = data_count;
  assign axis_wr_data_count = wr_data_count;
  assign axis_rd_data_count = rd_data_count;

endmodule