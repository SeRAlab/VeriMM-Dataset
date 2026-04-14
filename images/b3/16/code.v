module top_module(
  // inputs:
  input clk,
  input rd,
  input reset_n,
  input wr,
  input [43:0] wr_data,

  // outputs:
  output almost_empty,
  output almost_full,
  output empty,
  output full,
  output reg [43:0] rd_data // Change to reg since rd_data is driven in always block
);reg [1:0] entries; // number of entries in the FIFO
  reg [43:0] fifo [1:0]; // the FIFO
  reg [1:0] rd_address; // the read address
  reg [1:0] wr_address; // the write address

  // calculate the status signals
  assign almost_empty = (entries <= 1);
  assign almost_full = (entries >= 1);
  assign empty = (entries == 0);
  assign full = (entries == 2);

  // read data from the FIFO
  always @(*) begin
    case (rd_address)
      2'b00: rd_data = fifo[0];
      2'b01: rd_data = fifo[1];
      default: rd_data = 0;
    endcase
  end

  // write data to the FIFO
  always @(posedge clk) begin
    if (wr && !full) begin
      case (wr_address)
        2'b00: fifo[0] <= wr_data;
        2'b01: fifo[1] <= wr_data;
      endcase
      entries <= entries + 1;
      wr_address <= (wr_address == 2'b01) ? 2'b00 : wr_address + 1;
    end
  end

  // read data from the FIFO
  always @(posedge clk) begin
    if (rd && !empty) begin
      entries <= entries - 1;
      rd_address <= (rd_address == 2'b01) ? 2'b00 : rd_address + 1;
    end
  end

  // reset the FIFO
  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      entries <= 0;
      rd_address <= 2'b00;
      wr_address <= 2'b00;
    end
  end

endmodule