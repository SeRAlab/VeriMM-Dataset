module top_module(
  input clk,
  input reset,
  input [9:0] data,
  output reg match,
  output reg [1:0] state
);// Define states
  localparam IDLE = 2'b00;
  localparam STATE1 = 2'b01;
  localparam STATE2 = 2'b10;
  
  // Define pattern
  localparam PATTERN = 3'b101;
  
  // Define state register
  reg [1:0] state_reg;
  
  // Define match register
  reg match_reg;
  
  // Assign initial state
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      state_reg <= IDLE;
      match_reg <= 1'b0;
    end else begin
      state_reg <= IDLE;
      match_reg <= 1'b0;
    end
  end
  
  // Define next state logic
  always @ (posedge clk) begin
    case (state_reg)
      IDLE: begin
        if (data[9:7] == PATTERN[2:0]) begin
          state_reg <= STATE1;
        end
      end
      STATE1: begin
        if (data[8:6] == PATTERN[1:0]) begin
          state_reg <= STATE2;
        end else if (data[9:7] != PATTERN[2:0]) begin
          state_reg <= IDLE;
        end
      end
      STATE2: begin
        if (data[7:5] == PATTERN) begin
          match_reg <= 1'b1;
          state_reg <= IDLE;
        end else if (data[9:7] != PATTERN[2:0] || data[8:6] != PATTERN[1:0]) begin
          state_reg <= IDLE;
        end
      end
    endcase
  end
  
  // Assign state and match outputs
  always @ (state_reg, match_reg) begin
    state = state_reg;
    match = match_reg;
  end
  
endmodule