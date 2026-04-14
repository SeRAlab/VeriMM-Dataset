module top_module(
  input clk,
  input reset,
  input data,
  output reg [2:0] count
);reg [1:0] state;
  reg [2:0] count_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00;
      count_reg <= 3'b000;
    end
    else begin
      case (state)
        2'b00: begin
          if (data) begin
            state <= 2'b01;
          end
          else begin
            state <= 2'b00;
            count_reg <= 3'b000;
          end
        end
        2'b01: begin
          if (data) begin
            state <= 2'b10;
          end
          else begin
            state <= 2'b00;
            count_reg <= 3'b000;
          end
        end
        2'b10: begin
          if (data) begin
            state <= 2'b11;
          end
          else begin
            state <= 2'b00;
            count_reg <= 3'b000;
          end
        end
        2'b11: begin
          if (data) begin
            state <= 2'b11;
          end
          else begin
            state <= 2'b00;
            count_reg <= count_reg + 1;
          end
        end
      endcase
    end
  end

  assign count = count_reg;

endmodule