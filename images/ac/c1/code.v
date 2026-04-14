module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter INIT = 2'b0;
  parameter MATCH = 2'b1;
  
  reg [1:0] state;
  reg [3:0] shift_reg;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= INIT;
      shift_reg <= 4'b0;
      match <= 1'b0;
    end
    else begin
      case(state)
        INIT: begin
          if (shift_reg == 4'b1010) begin
            state <= MATCH;
            match <= 1'b1;
          end
          else begin
            shift_reg <= {shift_reg[2:0], data};
          end
        end
        MATCH: begin
          if (reset) begin
            state <= INIT;
            shift_reg <= 4'b0;
            match <= 1'b0;
          end
        end
      endcase
    end
  end
  
endmodule