module top_module(
  input clk,
  input reset,
  input [2:0] in,
  output reg [1:0] out
);reg [1:0] state;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00;
      out <= 2'b00;
    end
    else begin
      case (state)
        2'b00: begin
          if (in == 3'b00x) begin
            state <= 2'b00;
            out <= 2'b00;
          end
          else if (in == 3'b01x) begin
            state <= 2'b01;
            out <= 2'b01;
          end
          else if (in == 3'b10x) begin
            state <= 2'b10;
            out <= 2'b10;
          end
          else if (in == 3'b11x) begin
            state <= 2'b11;
            out <= 2'b11;
          end
        end
        2'b01: begin
          if (in == 3'b0x1) begin
            state <= 2'b00;
            out <= 2'b00;
          end
          else if (in == 3'b1x1) begin
            state <= 2'b01;
            out <= 2'b01;
          end
        end
        2'b10: begin
          if (in == 3'b1xx) begin
            state <= 2'b00;
            out <= 2'b00;
          end
          else if (in == 3'b0xx) begin
            state <= 2'b10;
            out <= 2'b10;
          end
        end
        2'b11: begin
          if (in == 3'b1x0) begin
            state <= 2'b00;
            out <= 2'b00;
          end
          else if (in == 3'b0x0) begin
            state <= 2'b11;
            out <= 2'b11;
          end
        end
      endcase
    end
  end
  
endmodule