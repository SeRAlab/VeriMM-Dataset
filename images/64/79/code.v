module top_module(
  input clk,
  input reset,
  input [5:0] data,
  output reg match
);reg [2:0] state;

parameter S0 = 3'd0;
parameter S1 = 3'd1;
parameter S2 = 3'd2;
parameter G1 = 3'd3;
parameter S3 = 3'd4;
parameter S4 = 3'd5;
parameter S5 = 3'd6;

always @(posedge clk) begin
  if (reset) begin
    state <= S0;
    match <= 0;
  end else begin
    case(state)
      S0: if (data[5] == 1) state <= S1;
          else state <= S0;
      S1: if (data[5] == 0) state <= S2;
          else state <= S0;
      S2: if (data[5] == 1) state <= G1;
          else state <= S0;
      G1: if (data[5] == 0) state <= S3;
          else state <= G1;
      S3: if (data[5] == 1) state <= S4;
          else state <= S0;
      S4: if (data[5] == 0) state <= S5;
          else state <= S0;
      S5: if (data[5] == 1) begin
            state <= S0;
            match <= 1;
          end else state <= S0;
      default: state <= S0;
    endcase
  end
end

endmodule