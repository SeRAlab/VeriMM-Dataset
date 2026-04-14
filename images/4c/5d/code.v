module top_module(
  input si, // serial input signal
  input clk, // clock signal
  input rst, // reset signal
  output so, // serial output signal
  output reg [n-1:0] po // parallel output signal
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] shift_reg; // shift register

always @(posedge clk) begin
  if (rst) begin
    shift_reg <= 0; // clear shift register
  end else begin
    shift_reg <= {shift_reg[n-2:0], si}; // shift input signal into shift register
  end
end

assign so = shift_reg[0]; // serial output signal

always @(*) begin
  po = shift_reg; // parallel output signal
end

endmodule