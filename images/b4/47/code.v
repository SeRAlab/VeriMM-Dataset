module top_module(
  input clk, // clock signal
  input [7:0] wr_ptr, // write pointer
  input [7:0] rd_ptr, // read pointer
  input ram_full, // RAM full flag
  input [7:0] addr, // RAM address to write to
  input [31:0] data, // data to be written
  output reg [7:0] new_wr_ptr, // updated write pointer
  output reg ram_full_out, // updated RAM full flag
  output reg write_success // write success flag
);// define RAM memory
  reg [31:0] memory [0:255];

  // define status flags
  reg [7:0] wr_status = 8'h00; // no errors
  reg [7:0] rd_status = 8'h00; // no errors

  // write operation
  always @ (posedge clk) begin
    if (wr_ptr == rd_ptr && !ram_full) begin
      // RAM is empty
      memory[addr] <= data;
      new_wr_ptr <= wr_ptr + 1;
      ram_full_out <= 0;
      write_success <= 1;
    end else if (wr_ptr != rd_ptr && wr_ptr != wr_ptr + 1) begin
      // RAM is not empty or full
      memory[addr] <= data;
      new_wr_ptr <= wr_ptr + 1;
      ram_full_out <= 0;
      write_success <= 1;
    end else begin
      // RAM is full
      new_wr_ptr <= wr_ptr;
      ram_full_out <= 1;
      write_success <= 0;
    end
  end

  // update status flags
  always @ (posedge clk) begin
    // update write status
    if (!write_success) begin
      wr_status <= 8'h01; // write error
    end else if (ram_full_out) begin
      wr_status <= 8'h02; // RAM full
    end else begin
      wr_status <= 8'h00; // no errors
    end

    // update read status
    if (rd_ptr == wr_ptr && !ram_full) begin
      rd_status <= 8'h01; // read error
    end else if (rd_ptr == wr_ptr && ram_full) begin
      rd_status <= 8'h02; // RAM empty
    end else begin
      rd_status <= 8'h00; // no errors
    end
  end

endmodule