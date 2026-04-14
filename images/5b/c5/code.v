module top_module(
  input clk,
  input rst,
  input ctrl,
  input load,
  input [15:0] load_val,
  output reg [15:0] count
);always @ (posedge clk) begin
  if (rst) begin
    count <= 0;
  end else if (load) begin
    count <= load_val;
  end else begin
    if (ctrl) begin
      count <= count + 1;
    end else begin
      count <= count - 1;
    end
  end
end

endmodule