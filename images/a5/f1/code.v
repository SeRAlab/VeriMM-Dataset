module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);reg [1:0]           state;
  reg                 prev_a;
  reg                 curr_a;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 2'b00;
      prev_a <= 1'b0;
      curr_a <= 1'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end else begin
      prev_a <= curr_a;
      curr_a <= a;
      case (state)
        2'b00: begin
          if (prev_a == 1'b0 && curr_a == 1'b1) begin
            rise <= 1'b1;
            down <= 1'b0;
            state <= 2'b01;
          end else if (prev_a == 1'b1 && curr_a == 1'b0) begin
            rise <= 1'b0;
            down <= 1'b1;
            state <= 2'b10;
          end else begin
            rise <= 1'b0;
            down <= 1'b0;
            state <= 2'b00;
          end
        end
        2'b01: begin
          rise <= 1'b0;
          down <= 1'b0;
          state <= 2'b10;
        end
        2'b10: begin
          rise <= 1'b0;
          down <= 1'b0;
          state <= 2'b00;
        end
      endcase
    end
  end

endmodule