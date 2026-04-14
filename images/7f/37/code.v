module top_module(
  input wire clk,
  input wire nrst,
  input wire [7:0] in_data,
  input wire in_valid,
  output wire in_ready,
  output reg [7:0] out_data,  // Change to reg type
  output wire out_valid,
  input wire out_ready
);parameter BUFFER_SIZE = 8;
  
  reg [7:0] buffer [0:BUFFER_SIZE-1];
  reg [2:0] write_ptr;
  reg [2:0] read_ptr;
  reg [2:0] count;
  
  always @(posedge clk) begin
    if (~nrst) begin
      write_ptr <= 3'b0;
      read_ptr <= 3'b0;
      count <= 3'b0;
      out_data <= 8'b0;  // Initialize out_data on reset
    end else begin
      if (in_valid && in_ready) begin
        buffer[write_ptr] <= in_data;
        write_ptr <= write_ptr + 1;
        count <= count + 1;
      end
      
      if (out_ready && count > 0) begin
        out_data <= buffer[read_ptr];
        read_ptr <= read_ptr + 1;
        count <= count - 1;
      end
    end
  end
  
  assign in_ready = (count < BUFFER_SIZE);
  assign out_valid = (count > 0);
  
endmodule