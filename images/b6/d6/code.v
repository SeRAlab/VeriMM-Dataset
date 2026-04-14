module top_module(
  input [n-1:0] in,
  output out,
  output reg chk // Change to reg
);parameter n = 8; // number of input signals

reg [n-1:0] count; // register to store the count of 1s in the input signals
reg parity_bit; // register to store the parity bit

// Generate the parity bit
always @(*) begin
  count = in; // count the number of 1s in the input signals
  parity_bit = ~^in; // generate the parity bit
end

// Output the parity bit for the parity generator
assign out = parity_bit;

// Check the parity bit for the parity checker
always @(*) begin
  count = in; // count the number of 1s in the input signals
  if (parity_bit) begin // if the parity bit is 1
    if (count % 2 == 0) begin // if the number of 1s is even
      chk = 1'b0; // output 0 for even parity
    end else begin // if the number of 1s is odd
      chk = 1'b1; // output 1 for odd parity
    end
  end else begin // if the parity bit is 0
    if (count % 2 == 0) begin // if the number of 1s is even
      chk = 1'b1; // output 1 for even parity
    end else begin // if the number of 1s is odd
      chk = 1'b0; // output 0 for odd parity
    end
  end
end

endmodule