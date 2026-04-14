module top_module(
  input clk,
  input reset,
  input [7:0] in,
  output reg match,
  output reg done
);reg [3:0] state;
  reg [3:0] next_state;
  
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= 4'b0000;
      match <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      match <= (state == 4'b0010);
      done <= (state == 4'b0100);
    end
  end
  
  always @(*) begin
    case (state)
      4'b0000: next_state = (in == 4'b1010) ? 4'b0010 : 4'b0001;
      4'b0001: next_state = (in[2:0] == 3'b010) ? 4'b0010 : 4'b0001;
      4'b0010: next_state = (in[1:0] == 2'b10) ? 4'b0100 : 4'b0001;
      4'b0100: next_state = 4'b0001;
      default: next_state = 4'b0000;
    endcase
  end
  
endmodule