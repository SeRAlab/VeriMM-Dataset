module top_module(
  output reg dataout,
  input clock,
  input reset,
  input datain
);// define the states
  parameter S0 = 2'b00; // initial state
  parameter S1 = 2'b01; // state after first 1
  parameter S2 = 2'b10; // state after second 1
  parameter S3 = 2'b11; // state after third 1

  // define the state register and next state logic
  reg [1:0] state, next_state;
  always @ (posedge clock, posedge reset)
  begin
    if (reset)
      state <= S0;
    else
      state <= next_state;
  end

  // define the output logic
  always @ (state, datain)
  begin
    case (state)
      S0: dataout <= 0;
      S1: dataout <= 0;
      S2: dataout <= 0;
      S3: dataout <= 1;
      default: dataout <= 0;
    endcase
  end

  // define the next state logic
  always @ (state, datain)
  begin
    case (state)
      S0: if (datain) next_state <= S1; else next_state <= S0;
      S1: if (datain) next_state <= S2; else next_state <= S0;
      S2: if (datain) next_state <= S3; else next_state <= S0;
      S3: if (datain) next_state <= S3; else next_state <= S0;
      default: next_state <= S0;
    endcase
  end

endmodule