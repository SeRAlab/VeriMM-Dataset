module top_module(
  input clk, // clock signal
  input rst, // reset signal
  input in, // input signal with glitches
  output out // filtered signal
);parameter n = 8; // number of flip-flops in the shift register

reg [n-1:0] shift_reg; // shift register to store input signal
wire glitch; // glitch signal
wire [n-1:0] shift_reg_next; // next state of shift register
wire out_next; // next state of output signal

// compute glitch signal
assign glitch = |(shift_reg ^ shift_reg_next);

// compute next state of shift register
assign shift_reg_next = {in, shift_reg[n-1:1]};

// compute next state of output signal
assign out_next = ~glitch & shift_reg_next[0];

// flip-flops to store shift register
always @(posedge clk or posedge rst) begin
  if (rst) begin
    shift_reg <= 0;
  end else begin
    shift_reg <= shift_reg_next;
  end
end

// assign output signal
assign out = out_next;

endmodule