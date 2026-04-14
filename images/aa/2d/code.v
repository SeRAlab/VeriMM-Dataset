module top_module(
  input [n-1:0] data,
  input sel,
  output parity,
  output [n:0] out
);parameter n = 8; // width of the data stream (number of bits)

reg [n-1:0] temp_data;
reg [n:0] temp_out;
reg temp_parity;

integer i;
integer count;

always @(*) begin
  count = 0;
  for (i = 0; i < n; i = i + 1) begin
    if (data[i] == 1) begin
      count = count + 1;
    end
  end
  
  if (sel == 0) begin // parity generator
    if (count % 2 == 0) begin // even parity
      temp_parity = 0;
      temp_out = {data, temp_parity};
    end
    else begin // odd parity
      temp_parity = 1;
      temp_out = {data, temp_parity};
    end
  end
  else begin // parity checker
    if (count % 2 == 0) begin // even parity
      temp_parity = 0;
      temp_out = data;
    end
    else begin // odd parity
      temp_parity = 1;
      temp_out = data ^ 1; // flip the last bit to correct the parity
    end
  end
end

assign parity = temp_parity;
assign out = temp_out;

endmodule