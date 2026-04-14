module top_module(
  input clk,
  input reset,
  output reg out
);parameter STATE_LOW = 2'b00;
  parameter STATE_HIGH = 2'b01;
  
  reg [1:0] state;
  
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= STATE_LOW;
      out <= 1'b0;
    end else begin
      case (state)
        STATE_LOW: begin
          state <= STATE_HIGH;
          out <= 1'b0;
        end
        STATE_HIGH: begin
          state <= STATE_LOW;
          out <= 1'b0;
        end
      endcase
    end
  end
  
endmodule