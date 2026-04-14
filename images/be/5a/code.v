module top_module(
  input clk,
  input reset,
  input i,
  output reg out
);// Define the states
  parameter IDLE = 2'b00;
  parameter STATE1 = 2'b01;
  parameter STATE2 = 2'b10;
  
  // Define the state register
  reg [1:0] state;
  
  // Define the output register
  reg out_reg;
  
  // Synchronous reset to IDLE state
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      out_reg <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (i) begin
            state <= STATE1;
          end else begin
            state <= IDLE;
          end
        end
        STATE1: begin
          if (i) begin
            state <= STATE2;
          end else begin
            state <= IDLE;
          end
        end
        STATE2: begin
          if (i) begin
            state <= STATE1;
            out_reg <= 1'b0;
          end else begin
            state <= IDLE;
            if (out_reg) begin
              out <= 1'b1;
            end
          end
        end
      endcase
    end
  end
  
  // Output register
  always @(posedge clk) begin
    if (reset) begin
      out <= 1'b0;
    end else begin
      out <= out_reg;
    end
  end
  
endmodule