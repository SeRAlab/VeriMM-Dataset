module top_module(
  input clk,
  input rd,
  input reset_n,
  input wr,
  input [42:0] wr_data,
  output almost_empty,
  output almost_full,
  output empty,
  output full,
  output reg [42:0] rd_data
);// internal signals
  reg [1:0] entries;
  reg [42:0] buffer [1:0];
  reg rd_address;
  reg [1:0] wr_address;
  wire [1:0] rdwr;

  assign rdwr = {rd, wr};
  assign full = (entries == 2);
  assign almost_full = (entries == 1);
  assign empty = (entries == 0);
  assign almost_empty = (entries <= 1);

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      entries <= 0;
      rd_address <= 0;
      wr_address <= 0;
      rd_data <= 0; // Initialize rd_data
    end else begin
      case (rdwr)
        2'b01: begin // read
          if (!empty) begin
            rd_data <= buffer[rd_address];
            rd_address <= (rd_address == 1) ? 0 : 1;
            entries <= entries - 1;
          end
        end
        2'b10: begin // write
          if (!full) begin
            buffer[wr_address] <= wr_data;
            wr_address <= (wr_address == 1) ? 0 : 1;
            entries <= entries + 1;
          end
        end
        2'b11: begin // read and write
          if (!empty) begin
            rd_data <= buffer[rd_address];
            rd_address <= (rd_address == 1) ? 0 : 1;
            entries <= entries - 1;
          end
          if (!full) begin
            buffer[wr_address] <= wr_data;
            wr_address <= (wr_address == 1) ? 0 : 1;
            entries <= entries + 1;
          end
        end
      endcase
    end
  end

endmodule