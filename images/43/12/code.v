module top_module(
  input clk,
  input reset,
  input [9:0] data,
  output reg match
);reg [1:0] state;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00;
      match <= 0;
    end else begin
      case (state)
        2'b00: begin // State 0
          if (data[0] == 1) begin
            state <= 2'b01;
          end
        end
        2'b01: begin // State 1
          if (data[0] == 1) begin
            state <= 2'b10;
          end else begin
            state <= 2'b00;
          end
        end
        2'b10: begin // State 2
          if (data[0] == 1) begin
            state <= 2'b11;
            match <= 1;
          end else begin
            state <= 2'b00;
          end
        end
        2'b11: begin // Match state
          state <= 2'b00;
        end
      endcase
    end
  end
  
endmodule