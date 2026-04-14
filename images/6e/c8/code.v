module top_module(
  input clk,
  input rst,
  input [7:0] data_in,
  input enq,
  input deq,
  output reg [7:0] data_out, // Changed to reg to allow assignment in always block
  output reg [9:0] count,     // Changed to reg to allow assignment in always block
  output reg [9:0] head,      // Changed to reg to allow assignment in always block
  output reg [9:0] tail       // Changed to reg to allow assignment in always block
);reg [7:0] queue[0:9]; // fixed-size array with a maximum capacity of 10 elements
  reg [3:0] oldest_index = 0; // index of the oldest element in the queue
  reg [1:0] error = 0; // flag indicating whether an error has occurred

  always @(posedge clk) begin
    if (rst) begin
      head <= 0;
      tail <= 0;
      count <= 0;
      oldest_index <= 0;
      error <= 0;
    end else begin
      if (enq && !deq) begin // add element to queue
        if (count == 10) begin // queue is full, overwrite oldest element
          queue[oldest_index] <= data_in;
          oldest_index <= (oldest_index + 1) % 10;
          head <= (head + 1) % 10;
          // tail remains unchanged because it's still pointing to the next insert position
        end else begin // add element to queue
          queue[tail] <= data_in;
          tail <= (tail + 1) % 10;
        end
        count <= count + 1;
      end else if (deq && !enq) begin // remove element from queue
        if (count == 0) begin // queue is empty, throw error
          error <= 1;
        end else begin // remove element from queue
          data_out <= queue[head];
          head <= (head + 1) % 10;
          count <= count - 1;
          // tail remains unchanged because it points to the next insert position
        end
      end // else do nothing case is implicit since no changes are made
    end
  end

endmodule