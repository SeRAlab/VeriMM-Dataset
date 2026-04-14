module counter (
  input clk,
  input reset,
  input enable,
  output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    count <= 4'b0;
  end else begin
    case ({enable, count})
      2'b00, 4'b1001: count <= 4'b0;
      2'b01: count <= count + 1;
    endcase
  end
end

endmodule
