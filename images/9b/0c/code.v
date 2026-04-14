module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter IDLE = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  
  reg [1:0] state;
  reg [3:0] shift_reg;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_reg <= 4'b0;
      match <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (data == 1'b1) begin
            shift_reg <= {shift_reg[2:0], data};
            state <= S1;
          end else begin
            shift_reg <= 4'b0;
            state <= IDLE;
          end
        end
        S1: begin
          if (data == 1'b0) begin
            shift_reg <= {shift_reg[2:0], data};
            state <= S2;
          end else begin
            shift_reg <= 4'b0;
            state <= IDLE;
          end
        end
        S2: begin
          if (data == 1'b1) begin
            shift_reg <= {shift_reg[2:0], data};
            match <= 1;
            state <= IDLE;
          end else begin
            shift_reg <= 4'b0;
            state <= IDLE;
          end
        end
      endcase
    end
  end
endmodule