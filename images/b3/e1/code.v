module top_module(
  input clk, // Added the clock input
  input [n-1:0] in,
  output reg [m-1:0] out // Changed output to reg type
);parameter n = 4; // number of input bits
parameter m = 8; // number of output bits

// Convolutional Encoder
reg [n:0] shift_reg;
wire [m-1:0] encoded_bits;

assign encoded_bits[0] = shift_reg[0] ^ shift_reg[1] ^ shift_reg[2] ^ shift_reg[3];
assign encoded_bits[1] = shift_reg[0] ^ shift_reg[1] ^ shift_reg[3];
assign encoded_bits[2] = shift_reg[0] ^ shift_reg[2] ^ shift_reg[3];
assign encoded_bits[3] = shift_reg[1] ^ shift_reg[2] ^ shift_reg[3];
assign encoded_bits[4] = shift_reg[0] ^ shift_reg[1] ^ shift_reg[2];
assign encoded_bits[5] = shift_reg[0] ^ shift_reg[2];
assign encoded_bits[6] = shift_reg[1] ^ shift_reg[3];
assign encoded_bits[7] = shift_reg[2] ^ shift_reg[3];

always @(posedge clk) begin
  shift_reg <= {shift_reg[n-1:0], in};
end

// Viterbi Decoder
reg [n-1:0] state;
reg [n-1:0] next_state;
reg [n-1:0] decoded_bits;

always @(posedge clk) begin
  state <= next_state;
  decoded_bits <= state;
end

always @(*) begin
  case (state)
    4'b0000: next_state = {state[2:0], encoded_bits[0]};
    4'b0001: next_state = {state[2:0], encoded_bits[1]};
    4'b0010: next_state = {state[2:0], encoded_bits[2]};
    4'b0011: next_state = {state[2:0], encoded_bits[3]};
    4'b0100: next_state = {state[2:0], encoded_bits[4]};
    4'b0101: next_state = {state[2:0], encoded_bits[5]};
    4'b0110: next_state = {state[2:0], encoded_bits[6]};
    4'b0111: next_state = {state[2:0], encoded_bits[7]};
    default: next_state = state;
  endcase
end

always @(posedge clk) begin
  out <= decoded_bits; // Update output in the clock domain
end

endmodule