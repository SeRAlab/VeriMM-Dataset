module top_module(
  input clk,
  input reset,
  input [3:0] data,
  output reg match
);reg [1:0] state;
  
  always @(posedge clk, negedge reset) begin
    if (!reset) begin
      state <= 2'b00; // initial state
      match <= 1'b0;
    end
    else begin
      case(state)
        2'b00: begin // State A
          if (data == 4'b1010) begin
            state <= 2'b01; // transition to State B
          end
          else begin
            state <= 2'b00;
          end
        end
        
        2'b01: begin // State B
          if (data == 4'b1010) begin
            state <= 2'b10; // transition to State C
            match <= 1'b1; // assert match signal
          end
          else begin
            state <= 2'b00; // transition back to State A
          end
        end
        
        2'b10: begin // State C (final state)
          state <= 2'b10;
        end
      endcase
    end
  end
  
endmodule