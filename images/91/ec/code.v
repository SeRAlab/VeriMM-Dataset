module top_module(
  input clk,
  input rd,
  input reset_n,
  input wr,
  input [61:0] wr_data,
  output reg almost_empty,
  output reg almost_full,
  output reg empty,
  output reg full,
  output reg [61:0] rd_data
);reg [1:0] entries;
  reg [61:0] entry_0;
  reg [61:0] entry_1;
  reg rd_address;
  reg wr_address;
  wire [1:0] rdwr;

  assign rdwr = {rd, wr};
  assign full = (entries == 2);
  assign empty = (entries == 0);
  assign almost_full = (entries == 1 || entries == 2);
  assign almost_empty = (entries == 0 || entries == 1);

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      entries <= 0;
      rd_address <= 0;
      wr_address <= 0;
    end else begin
      case (rdwr)
        2'b01: begin // read
          if (entries > 0) begin
            entries <= entries - 1;
            rd_address <= ~rd_address;
          end
        end
        2'b10: begin // write
          if (entries < 2) begin
            entries <= entries + 1;
            wr_address <= ~wr_address;
            if (wr_address == 0) begin
              entry_0 <= wr_data;
            end else begin
              entry_1 <= wr_data;
            end
          end
        end
        2'b11: begin // read and write
          if (entries < 2) begin
            entries <= entries + 1;
            wr_address <= ~wr_address;
            if (wr_address == 0) begin
              entry_0 <= wr_data;
            end else begin
              entry_1 <= wr_data;
            end
          end
          if (entries > 0) begin
            entries <= entries - 1;
            rd_address <= ~rd_address;
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if (rd_address == 0) begin
      rd_data <= entry_0;
    end else begin
      rd_data <= entry_1;
    end
  end

endmodule