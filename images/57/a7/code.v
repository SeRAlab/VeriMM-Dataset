module top_module(
  input clk,
  input reset,
  input signed [3:0] A,
  input signed [3:0] B,
  output reg signed [7:0] P // Changed to 'reg' type
);reg signed [7:0] P_reg;
  reg signed [3:0] A_reg;
  reg signed [3:0] B_reg;
  reg [2:0] state;

  always @(posedge clk) begin
    if (reset) begin
      P_reg <= 0;
      A_reg <= 0;
      B_reg <= 0;
      P <= 0; // Initialize P on reset
      state <= 0;
    end else begin
      case (state)
        0: begin
          P_reg <= {4'b0, A}; // Use input A directly
          A_reg <= A;
          B_reg <= B;
          state <= 1;
        end
        1: begin
          if (B_reg[0] == 1) begin
            P_reg <= P_reg - A_reg;
          end else begin
            P_reg <= P_reg + A_reg;
          end
          A_reg <= A_reg << 1;
          B_reg <= B_reg >> 1; // Right shift B_reg
          state <= 2;
        end
        2: begin
          if (B_reg == 0) begin
            state <= 3;
          end else begin
            state <= 1;
          end
        end
        3: begin
          P <= P_reg; // Assign P_reg to P
          state <= 0;
        end
      endcase
    end
  end

endmodule