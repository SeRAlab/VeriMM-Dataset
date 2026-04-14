module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter IDLE = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  
  reg [1:0] state;
  reg [3:0] shift_reg;

  always @(posedge clk, negedge reset) begin
    if(!reset) begin
      state <= IDLE;
      shift_reg <= 4'b0000;
      match <= 1'b0;
    end else begin
      case(state)
        IDLE: begin
          if(data == 1'b1) begin
            shift_reg <= {shift_reg[2:0], data};
            state <= S1;
          end else begin
            shift_reg <= 4'b0000;
          end
        end
        S1: begin
          if(data == 1'b0) begin
            shift_reg <= {shift_reg[2:0], data};
            state <= IDLE;
          end else begin
            shift_reg <= {shift_reg[2:0], data};
            state <= S2;
          end
        end
        S2: begin
          if(data == 1'b1) begin
            shift_reg <= {shift_reg[2:0], data};
            state <= S3;
          end else begin
            shift_reg <= {shift_reg[2:0], data};
            state <= IDLE;
          end
        end
        S3: begin
          if(data == 1'b1) begin
            shift_reg <= {shift_reg[2:0], data};
            state <= IDLE;
            match <= 1'b1;
          end else begin
            shift_reg <= {shift_reg[2:0], data};
            state <= IDLE;
          end
        end
      endcase
    end
  end
endmodule