module top_module(
  input clk,
  input reset,
  input enable,
  output reg[2:0] q,
  output reg cycle_end
);parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  
  reg[1:0] state;
  
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= S0;
      q <= 3'b000;
      cycle_end <= 1'b0;
    end
    else if (enable) begin
      case(state)
        S0: begin
          q <= 3'b001;
          state <= S1;
          cycle_end <= 1'b0;
        end
        S1: begin
          q <= 3'b010;
          state <= S2;
          cycle_end <= 1'b0;
        end
        S2: begin
          q <= 3'b011;
          state <= S0;
          cycle_end <= 1'b1;
        end
        default: begin
          q <= 3'b000;
          state <= S0;
          cycle_end <= 1'b0;
        end
      endcase
    end
  end

endmodule