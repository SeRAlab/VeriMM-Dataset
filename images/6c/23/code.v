module top_module(
  input clk,
  input fifo_clear,
  input fifo_rd,
  input rst_n,
  input [7:0] t_dat,
  input wr_rfifo,
  output fifo_EF,
  output [7:0] fifo_rdata,
  output rfifo_full,
  output [5:0] rfifo_used
);reg [7:0] fifo[63:0];
  reg [5:0] used;
  reg [5:0] rfifo_used_reg; // Changed variable name to avoid conflict
  reg full;
  reg wr_en;
  reg rd_en;
  reg [5:0] addr;
  reg [7:0] rdata; // Changed rdata to a reg type

  assign fifo_rdata = rdata;
  assign fifo_EF = (used == 0);
  assign rfifo_full = full;
  assign rfifo_used = rfifo_used_reg; // Assign the correct variable for output

  always @(posedge clk) begin
    if (!rst_n) begin
      used <= 0;
      full <= 0;
      wr_en <= 0;
      rd_en <= 0;
      addr <= 0;
      rfifo_used_reg <= 0; // Use the renamed variable
      rdata <= 0; // Initialize rdata on reset
    end
    else begin
      if (fifo_clear) begin
        used <= 0;
        full <= 0;
        wr_en <= 0;
        rd_en <= 0;
        addr <= 0;
        rfifo_used_reg <= 0; // Use the renamed variable
      end
      else begin
        if (wr_rfifo && !full) begin
          fifo[addr] <= t_dat;
          used <= used + 1;
          addr <= addr + 1;
          if (used == 63) full <= 1; // Check condition for full
          wr_en <= 1;
        end
        else begin
          wr_en <= 0;
        end

        if (fifo_rd && !fifo_EF) begin
          rdata <= fifo[0]; // Read from the FIFO
          used <= used - 1;
          addr <= addr - 1;
          if (used == 62) full <= 0; // Check condition for not full
          rd_en <= 1;
          rfifo_used_reg <= rfifo_used_reg + 1; // Use the renamed variable
        end
        else begin
          rd_en <= 0;
        end
      end
    end
  end

endmodule