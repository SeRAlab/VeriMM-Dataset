module top_module(
  input clk,
  input rst,
  input mosi,
  input ssel,
  input sample,
  output miso,
  output wr
);// Define the states of the SPI state machine
  parameter IDLE_STATE = 2'b00;
  parameter TRANSMIT_STATE = 2'b01;
  parameter RECEIVE_STATE = 2'b10;

  // Define the current state and next state variables
  reg [1:0] state, next_state;

  // Define the data variables for the MOSI and MISO signals
  reg mosi_data, miso_data;

  // Define the write signal variable
  reg wr_signal;

  // Initialize the state machine to the idle state
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE_STATE;
      next_state <= IDLE_STATE;
      mosi_data <= 0;
      miso_data <= 0;
      wr_signal <= 0;
    end
    else begin
      state <= next_state;
    end
  end

  // Define the state transitions and data transfer logic
  always @ (*) begin
    case (state)
      IDLE_STATE: begin
        if (ssel == 1'b1 && mosi == 1'b1) begin
          next_state = TRANSMIT_STATE;
        end
        else begin
          next_state = IDLE_STATE;
        end
        mosi_data = mosi;
        miso_data = 0;
        wr_signal = 0;
      end
      TRANSMIT_STATE: begin
        if (sample == 1'b1) begin
          next_state = RECEIVE_STATE;
        end
        else begin
          next_state = TRANSMIT_STATE;
        end
        mosi_data = mosi;
        miso_data = 0;
        wr_signal = 0;
      end
      RECEIVE_STATE: begin
        next_state = IDLE_STATE;
        mosi_data = mosi;
        miso_data = miso;
        wr_signal = 1;
      end
      default: begin
        next_state = IDLE_STATE;
        mosi_data = 0;
        miso_data = 0;
        wr_signal = 0;
      end
    endcase
  end

  // Assign the output signals based on the state machine logic
  assign miso = miso_data;
  assign wr = wr_signal;

endmodule