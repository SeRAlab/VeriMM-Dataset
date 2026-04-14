module top_module(
  input in1,
  input in2,
  output out1,
  output out2
);// Define the four states using two binary digits
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;

  // Define the current state and next state variables
  reg [1:0] current_state, next_state;

  // Define the output signals based on the current state of the FSM
  assign out1 = (current_state == S0 || current_state == S2) ? 1'b1 : 1'b0;
  assign out2 = (current_state == S1 || current_state == S2) ? 1'b1 : 1'b0;

  // Implement the state machine and the transitions between states
  always @(current_state, in1, in2) begin
    case (current_state)
      S0: begin
        if (in1) next_state = S1;
        else if (in2) next_state = S2;
        else if (in1 && in2) next_state = S3;
        else next_state = S0;
      end
      S1: begin
        if (in2) next_state = S3;
        else if (!in1) next_state = S0;
        else next_state = S1;
      end
      S2: begin
        if (in1) next_state = S3;
        else if (!in2) next_state = S0;
        else next_state = S2;
      end
      S3: begin
        if (!in1 && !in2) next_state = S0;
        else next_state = S3;
      end
    endcase
    current_state <= next_state;
  end

endmodule