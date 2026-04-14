module top_module(
  input in,
  output out
);// Define the states of the state machine
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  
  // Define the current state variable
  reg [1:0] state;
  
  // Define the output signal
  reg out_reg;
  
  // Implement the state machine using a case statement
  always @(posedge in) begin
    case (state)
      S0: begin
        if (in == 1'b1) begin
          state <= S1;
        end else begin
          state <= S0;
        end
      end
      S1: begin
        if (in == 1'b0) begin
          state <= S2;
        end else begin
          state <= S0;
        end
      end
      S2: begin
        if (in == 1'b1) begin
          state <= S0;
          out_reg <= 1'b1;
        end else begin
          state <= S0;
        end
      end
    endcase
  end
  
  // Assign the output signal
  assign out = out_reg;
  
endmodule