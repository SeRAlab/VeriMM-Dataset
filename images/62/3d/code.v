module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
  reg [1:0] state, next_state;
  
  always @ (posedge clk) begin
    if (reset) begin
      state <= S0;
      match <= 0;
    end else begin
      state <= next_state;
      case (state)
        S0: if (data) next_state <= S1; else next_state <= S0;
        S1: if (data) next_state <= S2; else next_state <= S0;
        S2: if (data) next_state <= S3; else next_state <= S0;
        S3: if (data) begin
              next_state <= S3;
              match <= 1;
            end else next_state <= S0;
      endcase
    end
  end
  
endmodule