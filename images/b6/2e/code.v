module top_module(
  input [n-1:0] in,
  output detected
);parameter n = 4; // number of input signals
parameter s = 4; // number of states in the state machine

reg [s-1:0] state; // current state of the state machine

// Define the states of the state machine
parameter IDLE = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

// Define the transitions between states
always @ (in) begin
  case (state)
    IDLE: if (in == 4'b1100) state <= S1;
          else state <= IDLE;
    S1:   if (in == 4'b0011) state <= S2;
          else if (in == 4'b1100) state <= S1;
          else state <= IDLE;
    S2:   if (in == 4'b1100) state <= S3;
          else if (in == 4'b0011) state <= S2;
          else state <= IDLE;
    S3:   if (in == 4'b0011) state <= S3;
          else state <= IDLE;
  endcase
end

// Set the output signal high when the entire input sequence has been detected
assign detected = (state == S3);

endmodule