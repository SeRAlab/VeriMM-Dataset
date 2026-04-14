module top_module(
  input reset,
  input clock,
  input enque,
  input deque,
  input [3:0] enque_data,
  output reg [3:0] deque_data,
  output reg enqued,
  output reg dequed,
  output reg is_full,
  output reg is_empty
);reg [3:0] mem [0:3];
  reg [1:0] head;
  reg [1:0] tail;
  reg [1:0] count;

  always @(posedge clock) begin
    if (reset) begin
      head <= 2'b00;
      tail <= 2'b00;
      count <= 2'b00;
      is_empty <= 1'b1;
      is_full <= 1'b0;
      enqued <= 1'b0;
      dequed <= 1'b0;
    end else begin
      if (enque && !is_full) begin
        mem[head] <= enque_data;
        head <= (head + 1) % 4;
        count <= count + 1;
        is_empty <= 1'b0;
        enqued <= 1'b1;
        if (count == 4) is_full <= 1'b1;
      end
      if (deque && !is_empty) begin
        deque_data <= mem[tail];
        tail <= (tail + 1) % 4;
        count <= count - 1;
        is_full <= 1'b0;
        dequed <= 1'b1;
        if (count == 0) is_empty <= 1'b1;
      end
    end
  end

endmodule