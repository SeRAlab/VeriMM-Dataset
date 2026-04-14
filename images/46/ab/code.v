module top_module(
  input clk_i,
  input reset_i,
  input v_i,
  input ready_o,
  input yumi_i,
  input yumi_op_i,
  input scan_not_dq_i,
  input read_write_same_addr,
  input v_r,
  output reg empty,
  output reg rptr_valid,
  output reg enque,
  output reg v_o,
  output reg yumi_o
);parameter FIFO_DEPTH = 16;
  parameter DATA_WIDTH = 32;

  reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
  reg [DATA_WIDTH-1:0] data_out;
  reg [DATA_WIDTH-1:0] data_in;
  reg [4:0] wr_ptr;
  reg [4:0] rd_ptr;
  reg [4:0] fifo_count;

  always @(posedge clk_i) begin
    if (reset_i) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      fifo_count <= 0;
      empty <= 1;
      rptr_valid <= 0;
      enque <= 1;
      v_o <= 0;
    end else begin
      if (v_i && enque) begin
        fifo[wr_ptr] <= {yumi_op_i, yumi_i};
        wr_ptr <= wr_ptr + 1;
        fifo_count <= fifo_count + 1;
        empty <= 0;
        if (fifo_count == FIFO_DEPTH) begin
          enque <= 0;
        end
      end

      if (ready_o && ~empty) begin
        data_out <= fifo[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        fifo_count <= fifo_count - 1;
        if (fifo_count == 0) begin
          empty <= 1;
        end
        rptr_valid <= 1;
      end else begin
        data_out <= 0;
        rptr_valid <= 0;
      end
    end
  end

  always @(posedge clk_i) begin
    if (reset_i) begin
      data_in <= 0;
    end else begin
      if (v_i && ready_o) begin
        data_in <= {yumi_op_i, yumi_i};
      end
    end
  end

  always @(posedge clk_i) begin
    if (reset_i) begin
      yumi_o <= 0;
    end else begin
      if (ready_o && ~empty) begin
        yumi_o <= data_out[DATA_WIDTH-1:0];
        v_o <= 1;
      end else begin
        yumi_o <= 0;
        v_o <= 0;
      end
    end
  end

endmodule