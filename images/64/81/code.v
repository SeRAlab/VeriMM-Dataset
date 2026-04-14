module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);reg [1:0]           state;
  reg                 a_d;
  reg                 a_dd;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 2'b00;
      a_d <= 1'b0;
      a_dd <= 1'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end
    else begin
      a_d <= a;
      a_dd <= a_d;
      case (state)
        2'b00: begin
          if (a && !a_d && !a_dd) begin
            rise <= 1'b1;
            down <= 1'b0;
            state <= 2'b01;
          end
          else if (!a && a_d && a_dd) begin
            rise <= 1'b0;
            down <= 1'b1;
            state <= 2'b10;
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