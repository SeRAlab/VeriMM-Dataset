module top_module(
  input clk,
  input reset,
  input [7:0] data1,
  input [7:0] data2,
  input [7:0] data3,
  input [7:0] data4,
  output reg match
);// Define states
  parameter IDLE = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;

  // Define state register and next state logic
  reg [1:0] state, next_state;
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Define match detection logic
  reg match1, match2, match3, match4;
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      match1 <= 0;
      match2 <= 0;
      match3 <= 0;
      match4 <= 0;
    end else begin
      match1 <= (data1 == 8'b10101010);
      match2 <= (data2 == 8'b01010101);
      match3 <= (data3 == 8'b10101010);
      match4 <= (data4 == 8'b01010101);
    end
  end

  // Define next state logic
  always @ (*) begin
    case (state)
      IDLE: begin
        if (match1) begin
          next_state = S1;
        end else begin
          next_state = IDLE;
        end
      end
      S1: begin
        if (match2) begin
          next_state = S2;
        end else if (match1) begin
          next_state = S1;
        end else begin
          next_state = IDLE;
        end
      end
      S2: begin
        if (match3) begin
          next_state = S3;
        end else if (match1) begin
          next_state = S1;
        end else begin
          next_state = IDLE;
        end
      end
      S3: begin
        if (match4) begin
          next_state = IDLE;
          match <= 1;
        end else if (match1) begin
          next_state = S1;
        end else begin
          next_state = IDLE;
        end
      end
      default: next_state = IDLE;
    endcase
  end

endmodule