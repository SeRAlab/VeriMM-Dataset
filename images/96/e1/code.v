module top_module(
  input clk,
  input reset,
  input quarter,
  input candy_bar_left,
  output reg [1:0] state,
  output reg dispense
);parameter IDLE = 2'b00;
  parameter ACCEPT = 2'b01;
  parameter DISPENSE = 2'b10;
  
  reg [1:0] current_state;
  reg [1:0] next_state;
  
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end
  
  always @ (*) begin
    case (current_state)
      IDLE: begin
        if (quarter) begin
          next_state = ACCEPT;
        end else begin
          next_state = IDLE;
        end
        dispense = 0;
      end
      
      ACCEPT: begin
        if (quarter) begin
          next_state = DISPENSE;
        end else begin
          next_state = ACCEPT;
        end
        dispense = 0;
      end
      
      DISPENSE: begin
        if (candy_bar_left && current_state == DISPENSE) begin
          next_state = IDLE;
        end else begin
          next_state = DISPENSE;
        end
        dispense = (current_state == DISPENSE) && candy_bar_left;
      end
      
      default: begin
        next_state = IDLE;
        dispense = 0;
      end
    endcase
  end
  
  assign state = current_state;
  
endmodule