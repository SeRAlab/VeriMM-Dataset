module top_module(
  input clk,
  input reset,
  input load,
  input [3:0] data_in,
  output reg [3:0] count
);// Define the three states of the FSM
  parameter [1:0]
    IDLE = 2'b00,
    COUNTING = 2'b01,
    LOADING = 2'b10;

  // Define the current state and next state variables
  reg [1:0] state, next_state;

  // Define the counter register
  reg [3:0] counter_reg;

  // Assign the current state to the next state at the beginning of each clock cycle
  always @ (posedge clk) begin
    state <= next_state;
  end

  // Define the FSM
  always @ (*) begin
    case (state)
      IDLE: begin
        if (reset) begin
          next_state = IDLE;
        end else if (load) begin
          next_state = LOADING;
        end else begin
          next_state = COUNTING;
        end
      end
      COUNTING: begin
        if (reset) begin
          next_state = IDLE;
        end else if (load) begin
          next_state = LOADING;
        end else begin
          next_state = COUNTING;
        end
      end
      LOADING: begin
        next_state = IDLE;
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

  // Define the output logic based on the current state
  always @ (*) begin
    case (state)
      IDLE: begin
        count <= counter_reg;
      end
      COUNTING: begin
        counter_reg <= counter_reg + 1;
        count <= counter_reg;
      end
      LOADING: begin
        counter_reg <= data_in;
        count <= counter_reg;
      end
      default: begin
        count <= counter_reg;
      end
    endcase
  end

endmodule