module top_module(
  input clk,
  input button,
  output reg [2:0] count
);reg [1:0] state;

always @(posedge clk) begin
  if (button) begin
    count <= count + 1;
    case (state)
      0: state <= 1;
      1: state <= 2;
      2: state <= 3;
      3: state <= 0;
    endcase
  end else begin
    state <= state;
  end
end

endmodule