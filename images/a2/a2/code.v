module top_module(
  input clk,
  input reset,
  input in1,
  input in2,
  input in3,
  input in4,
  output reg [3:0] out // Output width based on n = 8, which requires 3 bits
);parameter n = 8; // number of states
localparam STATE_WIDTH = $clog2(n); // Use $clog2 for constant expression

reg [STATE_WIDTH-1:0] state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 0;
  end else begin
    state <= next_state;
  end
end

always @* begin
  case (state)
    0: begin
      if (in1) begin
        next_state = 1;
      end else if (in2) begin
        next_state = 2;
      end else if (in3) begin
        next_state = 3;
      end else if (in4) begin
        next_state = 4;
      end else begin
        next_state = 0;
      end
    end
    1: begin
      if (in2) begin
        next_state = 2;
      end else if (in3) begin
        next_state = 3;
      end else if (in4) begin
        next_state = 4;
      end else begin
        next_state = 1;
      end
    end
    2: begin
      if (in3) begin
        next_state = 3;
      end else if (in4) begin
        next_state = 4;
      end else begin
        next_state = 2;
      end
    end
    3: begin
      if (in4) begin
        next_state = 4;
      end else begin
        next_state = 3;
      end
    end
    4: begin
      next_state = 4;
    end
    default: begin
      next_state = 0;
    end
  endcase
end

assign out = state;

endmodule