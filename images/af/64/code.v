module top_module(
  input clk,
  input [3:0] in,
  output reg match,
  output reg [1:0] state
);// Define states
  parameter IDLE = 2'b00;
  parameter STATE1 = 2'b01;
  parameter STATE2 = 2'b10;
  parameter MATCH = 2'b11;
  
  // Define sequence
  parameter [3:0] SEQ = 4'b0101;
  
  // Define state register
  reg [1:0] current_state;
  
  // Define next state logic
  always @ (posedge clk) begin
    case (current_state)
      IDLE: begin
        if (in == SEQ[0]) begin
          current_state <= STATE1;
        end else begin
          current_state <= IDLE;
        end
      end
      STATE1: begin
        if (in == SEQ[1]) begin
          current_state <= STATE2;
        end else begin
          current_state <= IDLE;
        end
      end
      STATE2: begin
        if (in == SEQ[2]) begin
          current_state <= MATCH;
        end else begin
          current_state <= IDLE;
        end
      end
      MATCH: begin
        current_state <= IDLE;
      end
    endcase
  end
  
  // Define match signal
  always @ (current_state) begin
    if (current_state == MATCH) begin
      match <= 1;
    end else begin
      match <= 0;
    end
  end
  
  // Define state signal
  always @ (current_state) begin
    state <= current_state;
  end
  
  // Initialize state register to IDLE
  initial begin
    current_state <= IDLE;
  end
  
endmodule