module top_module(
  input clk,
  input reset,
  input coin,
  input nickel,
  input dime,
  output reg vend_coke,
  output reg vend_pepsi,
  output reg vend_soda
);// Define the states
  parameter IDLE = 2'b00;
  parameter COKE = 2'b01;
  parameter PEPSI = 2'b10;
  parameter SODA = 2'b11;
  
  // Define the current state and next state variables
  reg [1:0] current_state, next_state;
  
  // Define the output variables
  reg coke_output, pepsi_output, soda_output;
  
  // Initialize the state and output variables
  initial begin
    current_state = IDLE;
    coke_output = 1'b0;
    pepsi_output = 1'b0;
    soda_output = 1'b0;
  end
  
  // Define the state transition logic
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end
  
  // Define the next state and output logic
  always @ (*) begin
    case (current_state)
      IDLE: begin
        if (dime) begin
          next_state = COKE;
          coke_output = 1'b1;
        end else if (nickel) begin
          next_state = PEPSI;
          pepsi_output = 1'b1;
        end else if (coin) begin
          next_state = SODA;
          soda_output = 1'b1;
        end else begin
          next_state = IDLE;
          coke_output = 1'b0;
          pepsi_output = 1'b0;
          soda_output = 1'b0;
        end
      end
      COKE: begin
        next_state = IDLE;
        coke_output = 1'b0;
        pepsi_output = 1'b0;
        soda_output = 1'b0;
      end
      PEPSI: begin
        next_state = IDLE;
        coke_output = 1'b0;
        pepsi_output = 1'b0;
        soda_output = 1'b0;
      end
      SODA: begin
        next_state = IDLE;
        coke_output = 1'b0;
        pepsi_output = 1'b0;
        soda_output = 1'b0;
      end
    endcase
  end
  
  // Assign the output variables
  assign vend_coke = coke_output;
  assign vend_pepsi = pepsi_output;
  assign vend_soda = soda_output;

endmodule