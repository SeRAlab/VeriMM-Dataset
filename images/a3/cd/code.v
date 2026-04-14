module top_module(
  input clk,
  input rst,
  input ctrl,
  input load,
  input [n-1:0] val,
  output reg [n-1:0] out
);parameter n = 4; // number of output signals
parameter mod = 0; // modulo value (optional)

reg [n-1:0] count;

always @(posedge clk) begin
  if (rst) begin
    count <= 0;
  end else if (load) begin
    count <= val;
  end else if (ctrl) begin
    count <= count + 1;
  end else begin
    count <= count - 1;
  end
  
  if (mod != 0 && count == mod) begin
    count <= 0;
  end
end

assign out = count;

endmodule