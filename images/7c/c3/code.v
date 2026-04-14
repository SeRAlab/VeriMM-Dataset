module top_module(
  input clk,
  input reset,
  input [3:0] data,
  output reg match
);parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

reg [1:0] state;
reg [3:0] shift_reg;

always @(posedge clk or negedge reset) begin
  if (reset == 0) begin
    state <= A;
    shift_reg <= 4'b0000;
    match <= 0;
  end
  else begin
    case (state)
      A: begin
        shift_reg <= {shift_reg[2:0], data};
        if (shift_reg == 4'b1010) begin
          match <= 1;
          state <= B;
        end
        else begin
          match <= 0;
          state <= A;
        end
      end
      B: begin
        match <= 0;
        state <= C;
      end
      C: begin
        match <= 0;
        state <= D;
      end
      D: begin
        match <= 0;
        state <= A;
      end
    endcase
  end
end

endmodule