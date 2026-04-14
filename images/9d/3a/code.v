module top_module(
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  output reg [7:0] P
);reg [4:0] m;
  reg [4:0] ac;
  reg [2:0] state;
  
  always @(posedge clk) begin
    if (reset) begin
      m <= 5'b0;
      ac <= 5'b0;
      state <= 3'b000;
      P <= 8'b0;
    end
    else begin
      case (state)
        3'b000: begin // State 0
          if (B[0]) begin
            ac <= {4'b0, A};
            P <= {4'b0, A};
          end
          else begin
            P <= 8'b0;
          end
          m <= {B[3:1], 2'b01};
          state <= 3'b001;
        end
        3'b001: begin // State 1
          if (m[0] && !m[1]) begin
            ac <= ac + {4'b0, A};
          end
          else if (!m[0] && m[1]) begin
            ac <= ac - {4'b0, A};
          end
          m <= {m[3:1], m[0]};
          state <= 3'b010;
        end
        3'b010: begin // State 2
          if (m[0] && !m[1]) begin
            ac <= ac + {4'b0, A};
          end
          else if (!m[0] && m[1]) begin
            ac <= ac - {4'b0, A};
          end
          m <= {m[3:1], m[0]};
          state <= 3'b011;
        end
        3'b011: begin // State 3
          P <= {ac[7:4], P[3:0]};
          m <= {m[3:1], m[0]};
          if (m == 5'b00001 || m == 5'b11111) begin
            state <= 3'b100;
          end
          else begin
            state <= 3'b001;
          end
        end
        3'b100: begin // State 4
          P <= {ac[7:4], P[3:0]};
          state <= 3'b101;
        end
        3'b101: begin // State 5
          state <= 3'b000;
        end
      endcase
    end
  end
  
endmodule