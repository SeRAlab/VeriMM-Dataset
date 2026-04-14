module top_module(
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 8; // number of input signals
parameter m = 16; // number of output signals (8 values and 8 counts)

// No additional parameters required for this module.

reg [n-1:0] current; // current input signal
reg [n-1:0] next; // next input signal
reg [m-1:0] encoded; // encoded output signals
reg [n-1:0] decoded; // decoded output signals
reg [3:0] state; // state variable for encoding/decoding state machine
reg [3:0] count; // count variable for encoding
reg [3:0] repeat_count; // added declaration for repeat_count

// Encoding state machine
localparam IDLE = 4'b0000;
localparam COUNT = 4'b0001;
localparam VALUE = 4'b0010;

// Decoding state machine
localparam DECODE_IDLE = 4'b0000;
localparam DECODE_VALUE = 4'b0001;
localparam DECODE_COUNT = 4'b0010;

// Initialize state machine and count variable
initial begin
  state = IDLE;
  count = 0;
  repeat_count = 0; // Initialize repeat_count
end

// Encoding state machine
always @(*) begin
  case(state)
    IDLE: begin
      count = 1;
      current = in;
      state = COUNT;
    end
    COUNT: begin
      if(in == current) begin
        count = count + 1;
      end
      else begin
        encoded = {encoded, current, count};
        count = 1;
        current = in;
        state = VALUE;
      end
    end
    VALUE: begin
      count = 1;
      current = in;
      state = COUNT;
    end
  endcase
end

// Decoding state machine
always @(*) begin
  repeat_count = 0; // Resets repeat_count for new decode
  case(state)
    DECODE_IDLE: begin
      current = in;
      repeat_count = 0;
      state = DECODE_VALUE;
    end
    DECODE_VALUE: begin
      if(repeat_count > 0) begin
        decoded = {decoded, current};
        repeat_count = repeat_count - 1;
      end
      else begin
        repeat_count = in; // Assuming 'in' holds the count value
        state = DECODE_COUNT;
      end
    end
    DECODE_COUNT: begin
      current = in; // Assuming 'in' holds the next value
      state = DECODE_VALUE;
    end
  endcase
end

// Assign output signals
assign out = (state == IDLE) ? encoded : decoded;

endmodule