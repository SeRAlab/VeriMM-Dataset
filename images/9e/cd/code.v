module top_module(
  input in,
  input load,
  input shift_left,
  output out
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] data; // shift register data

always @(*) begin
  if (load) begin
    data <= in; // load data in parallel
  end else begin
    if (shift_left) begin
      data <= {data[n-2:0], 1'b0}; // shift data left
    end else begin
      data <= {1'b0, data[n-1:1]}; // shift data right
    end
  end
end

assign out = data[n-1]; // output shifted data

endmodule