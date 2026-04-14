module top_module(
  input clk,
  input rd,
  input reset_n,
  input wr,
  input [61:0] wr_data,
  output almost_empty,
  output almost_full,
  output empty,
  output full,
  output reg [61:0] rd_data  // Change wire to reg
);wire [1:0] rdwr;
  reg [1:0] entries;
  reg [61:0] entry_0, entry_1;
  reg rd_address;
  reg wr_address;
  assign rdwr = {rd, wr};
  assign full = (entries == 2);
  assign almost_full = (entries >= 1);
  assign empty = (entries == 0);
  assign almost_empty = (entries <= 1);

  always @ (posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      entries <= 0;
      wr_address <= 0;
      rd_address <= 0;
    end else begin
      case (rdwr)
        2'b01: begin // read
          if (~empty) begin
            rd_data <= (rd_address == 0) ? entry_0 : entry_1;
            rd_address <= (rd_address == 0) ? 1 : 0;
            entries <= entries - 1;
          end
        end
        2'b10: begin // write
          if (~full) begin
            if (wr_address == 0) begin
              entry_0 <= wr_data;
            end else begin
              entry_1 <= wr_data;
            end
            wr_address <= ~wr_address;
            entries <= entries + 1;
          end
        end
        2'b11: begin // read and write
          if (~empty) begin
            rd_data <= (rd_address == 0) ? entry_0 : entry_1;
            rd_address <= (rd_address == 0) ? 1 : 0;
            entries <= entries - 1;
          end
          if (~full) begin
            if (wr_address == 0) begin
              entry_0 <= wr_data;
            end else begin
              entry_1 <= wr_data;
            end
            wr_address <= ~wr_address;
            entries <= entries + 1;
          end
        end
        default: begin
        end
      endcase
    end
  end

endmodule