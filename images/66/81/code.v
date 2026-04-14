module top_module(
  input                clk,
  input                rst_n,
  output reg  [7:0]    Q
);reg [7:0] Q_reg;
  reg [7:0] Q_next;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      Q_reg <= 8'b00000000;
    end else begin
      Q_reg <= Q_next;
    end
  end

  assign Q = Q_reg[3:0];

  always @(*) begin
    case(Q_reg)
      8'b00000000: Q_next = 8'b10000000;
      8'b10000000: Q_next = 8'b11000000;
      8'b11000000: Q_next = 8'b11100000;
      8'b11100000: Q_next = 8'b11110000;
      8'b11110000: Q_next = 8'b11111000;
      8'b11111000: Q_next = 8'b11111100;
      8'b11111100: Q_next = 8'b11111110;
      8'b11111110: Q_next = 8'b11111111;
      8'b11111111: Q_next = 8'b01111111;
      8'b01111111: Q_next = 8'b00111111;
      8'b00111111: Q_next = 8'b00011111;
      8'b00011111: Q_next = 8'b00001111;
      8'b00001111: Q_next = 8'b00000111;
      8'b00000111: Q_next = 8'b00000011;
      8'b00000011: Q_next = 8'b00000001;
      8'b00000001: Q_next = 8'b00000000;
      default: Q_next = 8'b00000000;
    endcase
  end

endmodule