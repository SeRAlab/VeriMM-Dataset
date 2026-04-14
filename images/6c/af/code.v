module top_module(
  input clk,
  input reset,
  input data_in,
  output reg data_out,
  output reg tx_en,
  output reg rx_en,
  output reg data_ready
);// Define the states of the UART state machine
  parameter IDLE = 2'b00;
  parameter RECEIVE = 2'b01;
  parameter WAIT_FOR_STOP = 2'b10;
  parameter TRANSMIT = 2'b11;

  // Define the shift register for received data
  reg [7:0] shift_reg;

  // Define the current state of the state machine
  reg [1:0] state;

  always @(posedge clk) begin
    if (reset) begin
      // Reset the shift register and state machine
      shift_reg <= 8'b0;
      state <= IDLE;
      tx_en <= 0;
      rx_en <= 0;
      data_ready <= 0;
    end else begin
      case (state)
        IDLE: begin
          // Wait for a start bit to be received
          if (!data_in) begin
            state <= RECEIVE;
            rx_en <= 1;
          end
        end
        RECEIVE: begin
          // Sample the data_in signal at the middle of each bit time
          shift_reg <= {shift_reg[6:0], data_in};
          if (shift_reg[7]) begin
            // All data bits have been received, wait for stop bit
            state <= WAIT_FOR_STOP;
            rx_en <= 0;
          end
        end
        WAIT_FOR_STOP: begin
          // Wait for the stop bit to be received
          if (data_in) begin
            // Stop bit received, prepare to transmit
            state <= TRANSMIT;
            tx_en <= 1;
            data_ready <= 1;
          end
        end
        TRANSMIT: begin
          // Shift out the data in the shift register
          data_out <= shift_reg[0];
          shift_reg <= {shift_reg[6:0], 1'b0};
          if (shift_reg[7]) begin
            // All data bits have been transmitted, return to IDLE state
            state <= IDLE;
            tx_en <= 0;
            data_ready <= 0;
          end
        end
      endcase
    end
  end

endmodule