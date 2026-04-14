module top_module(
  input         push_valid,
  output        push_ready,
  input  [7:0]  push_payload,
  input         pop_valid,
  output        pop_ready,
  output reg [7:0] pop_payload, // Changed to reg type for proper assignment
  input         flush,
  output [4:0]  occupancy,
  output [4:0]  availability,
  input         mainClk,
  input         systemReset
);reg [7:0] buffer [0:15];
  reg [3:0] head;
  reg [3:0] tail;
  reg [4:0] count;
  wire full = (count == 16);
  wire empty = (count == 0);

  assign push_ready = (!full);
  assign pop_ready = (!empty);

  assign occupancy = count; // Fixed occupancy output to just count
  assign availability = 16 - count; // Fixed availability calculation

  always @(posedge mainClk) begin
    if (systemReset) begin
      head <= 4'b0000;
      tail <= 4'b0000;
      count <= 0;
    end else begin
      if (flush) begin
        head <= 4'b0000;
        tail <= 4'b0000;
        count <= 0;
      end else begin
        if (push_valid && !full) begin
          buffer[head] <= push_payload;
          head <= head + 1;
          count <= count + 1;
        end
        if (pop_valid && !empty) begin
          pop_payload <= buffer[tail]; // pop_payload is now correctly assigned
          tail <= tail + 1;
          count <= count - 1;
        end
      end
    end
  end

endmodule