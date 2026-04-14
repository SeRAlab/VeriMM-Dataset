module top_module(
  input                clk,
  input                rst_n,
  input                up_down,
  output reg  [3:0]    Q
);reg [3:0] Q_next;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      Q <= 4'b0000;
    end else begin
      if (up_down) begin
        Q <= Q_next;
      end else begin
        Q <= ~Q_next;
      end
    end
  end
  
  always @(*) begin
    case(Q)
      4'b0000: Q_next = 4'b0001;
      4'b0001: Q_next = 4'b0011;
      4'b0011: Q_next = 4'b0111;
      4'b0111: Q_next = 4'b1110;
      4'b1110: Q_next = 4'b1100;
      4'b1100: Q_next = 4'b1000;
      4'b1000: Q_next = 4'b0000;
      default: Q_next = 4'bxxxx;
    endcase
  end
  
endmodule