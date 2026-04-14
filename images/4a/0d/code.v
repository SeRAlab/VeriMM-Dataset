module top_module(
  input clk,
  input reset,
  input [15:0] data,
  output reg [3:0] count
);parameter S0 = 2'b00;
  parameter S1 = 2'b01;

  reg [1:0] state;
  reg [3:0] count_reg;
  reg [3:0] count_next;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      count_reg <= 0;
      count <= 0;
    end else begin
      case (state)
        S0: begin
          if (data == 16'hFFFF) begin
            state <= S1;
            count_reg <= 1;
          end else begin
            state <= S0;
            count_reg <= 0;
          end
        end
        S1: begin
          if (data == 16'hFFFF) begin
            state <= S1;
            count_reg <= count_next;
          end else begin
            state <= S0;
            count_reg <= count_next;
          end
        end
      endcase
    end
  end

  always @(*) begin
    if (state == S0) begin
      count_next = 0;
    end else begin
      count_next = count_reg + 1;
    end

    if (data == 16'hFFFF) begin
      count = count_reg;
    end else begin
      count = 0;
    end
  end

endmodule