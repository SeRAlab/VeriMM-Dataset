module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);reg [1:0] state;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

always @(posedge clk) begin
  if (reset) begin
    state <= A;
    match <= 0;
  end
  else begin
    case (state)
      A: begin
        if (data) state <= B;
        else state <= A;
      end
      B: begin
        if (data) state <= C;
        else state <= A;
      end
      C: begin
        if (data) state <= D;
        else state <= A;
      end
      D: begin
        match <= 1;
        state <= A;
      end
      default: state <= A;
    endcase
  end
end

endmodule