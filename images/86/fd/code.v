module top_module(
  input clk,
  input reset,
  output reg [3:0] Q
);parameter RST_VAL = 0;

reg [3:0] state;

always @(posedge clk) begin
  case(state)
    4'd0: begin
      Q <= 4'd0;
      state <= 4'd1;
    end
    4'd1: begin
      Q <= Q + 1;
      state <= (Q == 4'd15) ? 4'd0 : 4'd1;
    end
  endcase
end

always @(posedge clk or posedge reset) begin
  if(reset) begin
    Q <= RST_VAL;
    state <= 4'd0;
  end
end

endmodule