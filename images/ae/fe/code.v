module top_module(
  input clk,      // Added clock input
  input in,
  output reg out  // Changed output to reg type to allow assignment in always block
);// Define the states
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  
  // Define the state register and next state logic
  reg [1:0] state, next_state;
  
  // Next state logic  
  always @ (posedge clk) begin
    case (state)
      S0: if (in) next_state = S1; else next_state = S0;
      S1: if (in) next_state = S2; else next_state = S0;
      S2: if (in) next_state = S3; else next_state = S0;
      S3: if (in) next_state = S3; else next_state = S0;
    endcase
  end
  
  // State register
  always @ (posedge clk) begin
    state <= next_state;
  end

  // Define the output logic
  always @ (posedge clk) begin
    if (state == S3) 
      out <= 1'b1;  // Assigned using non-blocking assignment
    else 
      out <= 1'b0; 
  end
  
endmodule