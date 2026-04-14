module top_module(
  input clk, rst, start, load, shift,
  output reg [2:0] currentState,
  output reg startTimer
);parameter DIVIDER = 3;
  reg [DIVIDER-1:0] timer;
  
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      currentState <= 3'b000;
      startTimer <= 0;
      timer <= 0;
    end else begin
      case (currentState)
        3'b000: begin
          if (start) begin
            currentState <= 3'b001;
            startTimer <= 1;
            timer <= 0;
          end
        end
        3'b001: begin
          startTimer <= 0;
          if (timer == DIVIDER-1) begin
            if (load) begin
              currentState <= 3'b010;
              timer <= 0;
            end else if (shift) begin
              currentState <= 3'b100;
              timer <= 0;
            end else begin
              currentState <= 3'b000;
              timer <= 0;
            end
          end else begin
            timer <= timer + 1;
          end
        end
        3'b010: begin
          if (timer == DIVIDER-1) begin
            currentState <= 3'b001;
            timer <= 0;
          end else begin
            timer <= timer + 1;
          end
        end
        3'b100: begin
          if (timer == DIVIDER-1) begin
            currentState <= 3'b001;
            timer <= 0;
          end else begin
            timer <= timer + 1;
          end
        end
      endcase
    end
  end
endmodule