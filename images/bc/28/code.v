module top_module(
  input [n-1:0] in,
  output reg [clog2(n)-1:0] out
);parameter n = 8; // number of input signals

// Function to calculate the ceiling of log2(n)
function integer clog2;
  input integer value;
  begin
    clog2 = 0;
    value = value - 1;
    while (value > 0) begin
      value = value >> 1;
      clog2 = clog2 + 1;
    end
  end
endfunction

always @(*) begin
  casez(in)
    8'b10000000: out = 3'b000;
    8'b01000000: out = 3'b001;
    8'b00100000: out = 3'b010;
    8'b00010000: out = 3'b011;
    8'b00001000: out = 3'b100;
    8'b00000100: out = 3'b101;
    8'b00000010: out = 3'b110;
    8'b00000001: out = 3'b111;
    default: out = 3'b000; // Address case where all inputs are 0
  endcase
end

endmodule