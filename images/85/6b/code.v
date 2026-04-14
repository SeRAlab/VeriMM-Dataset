module top_module(
  input clk,
  input reset,
  output reg [2:0] light
);// Define the states
  parameter GREEN = 2'b10;
  parameter YELLOW = 2'b01;
  parameter RED = 2'b00;
  
  // Define the state register and initialize to GREEN
  reg [1:0] state = GREEN;
  
  // Define the state transition logic
  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      state <= GREEN;
    end else begin
      case (state)
        GREEN: state <= YELLOW;
        YELLOW: state <= RED;
        RED: state <= YELLOW;
      endcase
    end
  end
  
  // Define the output logic
  always @(*) begin
    case (state)
      GREEN: light = 3'b100;
      YELLOW: light = 3'b010;
      RED: light = 3'b001;
    endcase
  end
  
endmodule