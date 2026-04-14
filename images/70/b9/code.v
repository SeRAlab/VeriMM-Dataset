module top_module(
  input clk,
  input reset_n,
  input wr,
  input [7:0] wr_data,
  input rd,
  output reg [7:0] rd_data,  // Changed to reg to allow assignment
  output full,
  output empty
);reg [7:0] buffer [0:7];
  reg [2:0] wr_ptr;
  reg [2:0] rd_ptr;
  reg [2:0] next_wr_ptr;
  reg [2:0] next_rd_ptr;
  reg [2:0] entries;
  reg [2:0] next_entries;      // Changed to reg to allow assignment
  
  assign full = (entries == 3'b111);  // Use 3'b111 for 8 entries
  assign empty = (entries == 3'b000);
  
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      wr_ptr <= 3'b000;
      rd_ptr <= 3'b000;
      entries <= 3'b000;
    end else begin
      wr_ptr <= next_wr_ptr;
      rd_ptr <= next_rd_ptr;
      entries <= next_entries;
    end
  end
  
  always @(*) begin
    next_wr_ptr = wr_ptr;
    next_rd_ptr = rd_ptr;
    next_entries = entries;
    
    if (wr && ~full) begin
      next_wr_ptr = (wr_ptr == 3'b111) ? 3'b000 : wr_ptr + 1;
      buffer[wr_ptr] = wr_data;
      next_entries = entries + 1;
    end
    
    if (rd && ~empty) begin
      next_rd_ptr = (rd_ptr == 3'b111) ? 3'b000 : rd_ptr + 1;
      rd_data = buffer[rd_ptr];
      next_entries = entries - 1;
    end
  end

endmodule