module top_module(
  input [n-1:0] data,
  input enable,
  input reset,
  output [d-1:0] crc,
  output reg valid // Changed to reg
);parameter n = 16; // number of data bits
parameter d = 8; // degree of generator polynomial (x^8 + x^2 + x + 1)

reg [n+d-2:0] message; // transmitted message
reg [d-1:0] remainder; // remainder after polynomial division
reg [n+d-2:0] received_message; // received message
wire [d-1:0] divisor = {8'h1, 8'h4, 8'h6, 8'h5, 8'h2, 8'h7, 8'h3, 8'h0}; // generator polynomial

// CRC generator
always @ (posedge enable or posedge reset) begin
  if (reset) begin
    message <= {n+d-2{1'b0}}; // reset message to all zeros
    remainder <= {d{1'b0}}; // also reset remainder
  end else if (enable) begin
    message <= {data, remainder}; // append remainder to data
    remainder <= message % divisor; // perform polynomial division
  end
end

// CRC checker
always @ (posedge enable or posedge reset) begin
  if (reset) begin
    received_message <= {n+d-2{1'b0}}; // reset received message to all zeros
    valid <= 0; // reset valid signal
  end else if (enable) begin
    received_message <= {data, crc}; // append CRC to data
    remainder <= received_message % divisor; // perform polynomial division
    valid <= (remainder == 0); // check if remainder is zero
  end
end

assign crc = remainder; // output remainder as CRC

endmodule