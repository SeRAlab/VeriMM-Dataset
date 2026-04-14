module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

reg [1:0] state;
reg match_reg;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= S0;
    match_reg <= 1'b0;
  end
  else begin
    case (state)
      S0: begin
        if (data == 1'b1)
          state <= S1;
        else
          state <= S0;
      end
      S1: begin
        if (data == 1'b0)
          state <= S0;
        else
          state <= S2;
      end
      S2: begin
        if (data == 1'b1)
          match_reg <= 1'b1;
        state <= S0;
      end
      default: state <= S0;
    endcase
  end
end

assign match = match_reg;

endmodule