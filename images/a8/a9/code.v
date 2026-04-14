module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
  reg [1:0] state;
  reg [4:0] shift_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      shift_reg <= 5'b0;
      match <= 1'b0;
    end else begin
      case (state)
        S0: begin
          if (data) begin
            shift_reg <= {shift_reg[3:0], data};
            state <= S1;
          end else begin
            shift_reg <= 5'b0;
          end
        end
        S1: begin
          if (data) begin
            shift_reg <= {shift_reg[3:0], data};
            state <= S2;
          end else begin
            shift_reg <= 5'b0;
            state <= S0;
          end
        end
        S2: begin
          if (data) begin
            shift_reg <= {shift_reg[3:0], data};
            state <= S3;
          end else begin
            shift_reg <= 5'b0;
            state <= S0;
          end
        end
        S3: begin
          if (shift_reg == 5'b10110) begin
            match <= 1'b1;
          end else begin
            match <= 1'b0;
          end
          shift_reg <= 5'b0;
          state <= S0;
        end
      endcase
    end
  end

endmodule