module top_module(
  input btnA,
  input btnB,
  input btnC,
  output reg dispenseBar,
  output reg dispenseChips,
  output reg dispenseSoda
);reg [1:0] state;

  parameter IDLE = 2'b00;
  parameter DISPENSING = 2'b01;
  parameter RESET = 2'b10;

  always @* begin
    case(state)
      IDLE: begin
        dispenseBar = 0;
        dispenseChips = 0;
        dispenseSoda = 0;
        if(btnA) begin
          dispenseBar = 1;
          state = DISPENSING;
        end else if(btnB) begin
          dispenseChips = 1;
          state = DISPENSING;
        end else if(btnC) begin
          dispenseSoda = 1;
          state = DISPENSING;
        end else begin
          state = IDLE;
        end
      end
      DISPENSING: begin
        dispenseBar = 0;
        dispenseChips = 0;
        dispenseSoda = 0;
        state = RESET;
      end
      RESET: begin
        dispenseBar = 0;
        dispenseChips = 0;
        dispenseSoda = 0;
        state = IDLE;
      end
      default: begin
        dispenseBar = 0;
        dispenseChips = 0;
        dispenseSoda = 0;
        state = IDLE;
      end
    endcase
  end

endmodule