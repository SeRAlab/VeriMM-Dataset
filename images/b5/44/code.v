module top_module(
  input                clk,        // Clock input
  input                rst_n,      // Asynchronous active-low reset input
  input                direction,  // Direction control input
  output reg  [63:0]   Q           // 64-bit output
);reg [7:0] state;  // 8-bit shift register to store current state

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 8'b00000000;  // Reset state to 00000000
      Q <= 64'b0;            // Reset output to 0
    end
    else begin
      if (direction) begin  // Increment counter
        state <= {state[6:0], state[7]};
      end
      else begin            // Decrement counter
        state <= {state[0], state[7:1]};
      end
      
      case(state)
        8'b00000000: Q <= 64'b0000000000000000;
        8'b10000000: Q <= 64'b0000000000000001;
        8'b11000000: Q <= 64'b0000000000000011;
        8'b11100000: Q <= 64'b0000000000000111;
        8'b11110000: Q <= 64'b0000000000001111;
        8'b11111000: Q <= 64'b0000000000011111;
        8'b11111100: Q <= 64'b0000000000111111;
        8'b11111110: Q <= 64'b0000000001111111;
        8'b11111111: Q <= 64'b0000000011111111;
        8'b01111111: Q <= 64'b0000000111111111;
        8'b00111111: Q <= 64'b0000001111111111;
        8'b00011111: Q <= 64'b0000011111111111;
        8'b00001111: Q <= 64'b0000111111111111;
        8'b00000111: Q <= 64'b0001111111111111;
        8'b00000011: Q <= 64'b0011111111111111;
        8'b00000001: Q <= 64'b0111111111111111;
      endcase
    end
  end

endmodule