module top_module(
  input clk, rst_n, fifo_rd, fifo_wr,
  input [7:0] data_in,
  output reg [7:0] data_out, // Change to reg since it will be assigned in an always block
  output reg empty, full,    // Change to reg since they are assigned in an always block
  output reg [3:0] count
);reg [7:0] buffer [0:15];
  reg [3:0] head, tail;
  reg [3:0] count_next;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      head <= 0;
      tail <= 0;
      count <= 0;
      empty <= 1;
      full <= 0;
      // The buffer does not need to be initialized like this, 
      // as it will hold its memory state on reset
    end else begin
      if (fifo_wr && ~full) begin
        buffer[head] <= data_in; // Writing data into the buffer
        head <= head + 1;
        count_next <= count + 1;
      end else begin
        count_next <= count;
      end
      if (fifo_rd && ~empty) begin
        data_out <= buffer[tail]; // Output data being read from the buffer
        tail <= tail + 1;
        count_next <= count - 1;
      end
      empty <= (head == tail);
      full <= (count_next == 16); // Full if count is 16
      count <= count_next;
    end
  end

endmodule