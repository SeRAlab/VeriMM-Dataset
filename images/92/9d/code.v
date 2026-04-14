module top_module(
  input clk, // Added clock input
  input [n-1:0] in,
  output detected
);parameter n = 4; // number of input signals
parameter seq = 4'b1010; // sequence to be detected

reg [3:0] state; // state register
reg [3:0] next_state; // next state register
wire match; // signal to indicate a match

assign detected = (state == 3); // output signal when final state is reached

always @(*) begin
  case (state)
    0: begin // initial state
      if (in == seq[0]) begin
        next_state = 1;
      end else begin
        next_state = 0;
      end
    end
    1: begin // second state
      if (in == seq[1]) begin
        next_state = 2;
      end else if (in == seq[0]) begin
        next_state = 1;
      end else begin
        next_state = 0;
      end
    end
    2: begin // third state
      if (in == seq[2]) begin
        next_state = 3;
      end else if (in == seq[0]) begin
        next_state = 1;
      end else begin
        next_state = 0;
      end
    end
    3: begin // final state
      next_state = 3;
    end
    default: next_state = 0; // handle unexpected states
  endcase
end

always @(posedge clk) begin
  state <= next_state; // update state register
end

endmodule