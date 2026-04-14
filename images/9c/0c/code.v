module top_module(
  input clk,
  input reset,
  input enable,
  output reg [3:0] count
);// Define states
  localparam IDLE = 2'b00;
  localparam COUNT = 2'b01;
  
  // Define state register and next state logic
  reg [1:0] state, next_state;
  always @ (posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end
  
  // Define counter
  reg [3:0] counter;
  
  // Define output logic
  always @ (*) begin
    count = counter;
  end
  
  // Define state machine
  always @ (state, enable) begin
    case (state)
      IDLE: begin
        if (enable) begin
          next_state = COUNT;
        end else begin
          next_state = IDLE;
        end
      end
      COUNT: begin
        if (counter == 4'b1111) begin
          next_state = IDLE;
          counter <= 4'b0000;
        end else begin
          next_state = COUNT;
          counter <= counter + 1;
        end
      end
      default: next_state = IDLE;
    endcase
  end
  
endmodule