module top_module(
  input clk,
  input [3:0] binary,
  output reg [3:0] gray,
  output reg match
);reg [3:0] next_gray;
  reg [2:0] state;

  always @(posedge clk) begin
    case(state)
      3'b000: begin // State 0 - Initialize
        next_gray <= binary;
        gray <= binary;
        match <= 1'b0;
        state <= 3'b001;
      end
      3'b001: begin // State 1 - Bit 3
        next_gray[3] <= binary[3] ^ binary[2];
        state <= 3'b010;
      end
      3'b010: begin // State 2 - Bit 2
        next_gray[2] <= binary[2] ^ binary[1];
        state <= 3'b011;
      end
      3'b011: begin // State 3 - Bit 1
        next_gray[1] <= binary[1] ^ binary[0];
        state <= 3'b100;
      end
      3'b100: begin // State 4 - Bit 0
        next_gray[0] <= binary[0];
        gray <= next_gray;
        if (next_gray == 4'b0101) begin // Check for match
          match <= 1'b1;
        end else begin
          match <= 1'b0;
        end
        state <= 3'b001;
      end
    endcase
  end

endmodule