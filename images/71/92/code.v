module top_module(
  input clk,
  input reset,
  input [3:0] data,
  output reg match
);reg [1:0] state;
  
  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      state <= 2'b00;
      match <= 0;
    end
    else begin
      case (state)
        2'b00: begin // Waiting for first '1'
          if (data == 4'b0001)
            state <= 2'b01;
        end
        2'b01: begin // Waiting for '0'
          if (data == 4'b0010)
            state <= 2'b10;
          else if (data != 4'b0001)
            state <= 2'b00;
        end
        2'b10: begin // Waiting for second '1'
          if (data == 4'b0001) begin
            state <= 2'b11;
            match <= 1;
          end
          else if (data == 4'b0010)
            state <= 2'b10;
          else
            state <= 2'b00;
        end
        2'b11: begin // Waiting for '0'
          if (data == 4'b0010)
            state <= 2'b00;
        end
      endcase
    end
  end

endmodule