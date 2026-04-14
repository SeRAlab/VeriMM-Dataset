module top_module(
  input [3:0] in_val,
  output reg [1:0] out_val
);always @(*) begin
  if ((in_val % 3 == 0) && (in_val % 5 == 0)) begin
    out_val = 2'b10;
  end
  else if (in_val % 3 == 0) begin
    out_val = 2'b00;
  end
  else if (in_val % 5 == 0) begin
    out_val = 2'b01;
  end
  else begin
    out_val = 2'b11;
  end
end

endmodule