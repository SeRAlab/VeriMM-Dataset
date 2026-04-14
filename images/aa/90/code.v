module top_module(
  input [n-1:0] data,
  input ctrl,
  output reg [m-1:0] hamming,
  output reg [n-1:0] corrected
);parameter n = 4; // length of the data word
parameter m = 7; // length of the Hamming code word
parameter r = 3; // number of redundant bits

// Encoder
wire [r-1:0] parity;
assign parity = {data[0]^data[1]^data[3], data[0]^data[2]^data[3], data[1]^data[2]^data[3]};

always @ (posedge ctrl) begin
  if (ctrl) begin
    hamming[0] <= parity[0];
    hamming[1] <= parity[1];
    hamming[2] <= data[0];
    hamming[3] <= parity[2];
    hamming[4] <= data[1];
    hamming[5] <= data[2];
    hamming[6] <= data[3];
  end
end

// Decoder
wire [r-1:0] syndrome;
assign syndrome = {hamming[0]^hamming[2]^hamming[4]^hamming[6], hamming[1]^hamming[2]^hamming[5]^hamming[6], hamming[3]^hamming[4]^hamming[5]^hamming[6]};

always @ (posedge ctrl) begin
  if (!ctrl) begin
    if (syndrome == 0) begin
      corrected <= data;
    end else begin
      corrected <= {data[0]^syndrome[2], data[1]^syndrome[1], data[2]^syndrome[0], data[3]};
    end
  end
end

endmodule