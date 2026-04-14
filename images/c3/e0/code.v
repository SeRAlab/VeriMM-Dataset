module concat_8bit (
  input clk,
  input reset,
  input [7:0] a,
  input [7:0] b,
  input ctrl,
  output [15:0] out
);

reg [15:0] temp;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    temp <= 16'b0;
  end else begin
    if (ctrl) begin
      temp <= {a, b};
    end else begin
      temp <= {b, a};
    end
  end
end

assign out = temp;

endmodule
