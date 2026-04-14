module top_module(
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of bits in the binary code (i.e., log2(n))

reg [m-1:0] out_reg; // register to hold the output binary code

always @(*) begin
  casez(in) // scan the input signals from highest to lowest priority
    4'b1110: out_reg = 2'b00; // highest priority input signal is in[3]
    4'b1101: out_reg = 2'b01; // highest priority input signal is in[2]
    4'b1011: out_reg = 2'b10; // highest priority input signal is in[1]
    4'b0111: out_reg = 2'b11; // highest priority input signal is in[0]
    default: out_reg = 2'b00; // default output if no input signals are high
  endcase
end

assign out = out_reg; // assign the output to the output register

endmodule