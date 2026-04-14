module top_module(
  input [1:0] address,
  input clk,
  input [8:0] in_port,
  input reset_n,
  output reg [31:0] readdata
);reg [8:0] fifo [7:0];
  reg [2:0] wr_ptr, rd_ptr;
  reg [2:0] fifo_count;
  reg data_flag;
  wire clk_en;

  assign clk_en = 1;

  always @ (posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      wr_ptr <= 3'b000;
      rd_ptr <= 3'b000;
      fifo_count <= 3'b000;
      data_flag <= 1'b0;
      readdata <= 0;
    end else if (clk_en) begin
      case (address)
        2'b00: begin // Write operation
          if (fifo_count < 3'b100) begin
            fifo[wr_ptr] <= in_port;
            wr_ptr <= wr_ptr + 1;
            fifo_count <= fifo_count + 1;
          end
          if (fifo_count == 3'b100) begin
            data_flag <= 1'b1;
          end
        end
        2'b01: begin // Read operation
          if (fifo_count > 3'b000) begin
            readdata <= {fifo[rd_ptr], 24'b0};
            rd_ptr <= rd_ptr + 1;
            fifo_count <= fifo_count - 1;
          end
          if (fifo_count == 3'b001) begin
            data_flag <= 1'b0;
          end
        end
        2'b10: begin // Data flag check operation
          readdata <= {24'b0, data_flag};
        end
      endcase
    end
  end

endmodule