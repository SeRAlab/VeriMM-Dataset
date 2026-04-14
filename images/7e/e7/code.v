module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);reg [1:0]           state;
  reg                 a_reg;
  reg                 a_reg_reg;

  parameter           IDLE = 2'b00;
  parameter           RISING_EDGE = 2'b01;
  parameter           FALLING_EDGE = 2'b10;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= IDLE;
      a_reg <= 1'b0;
      a_reg_reg <= 1'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end
    else begin
      a_reg <= a;
      a_reg_reg <= a_reg;
      case (state)
        IDLE: begin
          if (a_reg && ~a_reg_reg) begin
            rise <= 1'b1;
            down <= 1'b0;
            state <= RISING_EDGE;
          end
          else if (~a_reg && a_reg_reg) begin
            rise <= 1'b0;
            down <= 1'b1;
            state <= FALLING_EDGE;
          end
          else begin
            rise <= 1'b0;
            down <= 1'b0;
            state <= IDLE;
          end
        end
        RISING_EDGE: begin
          rise <= 1'b0;
          down <= 1'b0;
          state <= IDLE;
        end
        FALLING_EDGE: begin
          rise <= 1'b0;
          down <= 1'b0;
          state <= IDLE;
        end
      endcase
    end
  end

endmodule