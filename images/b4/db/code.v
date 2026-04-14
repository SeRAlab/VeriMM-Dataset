module top_module(
  input clk, // clock signal
  input rst, // reset signal
  input mosi, // master output, slave input signal
  input ssel, // slave select signal
  output reg miso // master input, slave output signal
);// Define the states of the SPI state machine
localparam IDLE = 2'b00;
localparam TRANSFER = 2'b01;
localparam RECEIVE = 2'b10;
localparam DONE = 2'b11;

// Define the current state and next state variables
reg [1:0] state, next_state;

// Define the output/input of the mosi/miso signal and the ssel signal
reg mosi_out, miso_in, ssel_out;

// Initialize the state machine to the IDLE state
always @(posedge clk, posedge rst) begin
  if (rst) begin
    state <= IDLE;
    miso <= 1'b1;
    ssel_out <= 1'b0;
  end else begin
    state <= next_state;
    miso <= miso_in;
    ssel_out <= ssel;
  end
end

// Define the state transitions and output/input control
always @(*) begin
  case (state)
    IDLE: begin
      miso_in = 1'b1;
      mosi_out = mosi;
      if (ssel == 1'b0) begin
        next_state = TRANSFER;
      end else begin
        next_state = IDLE;
      end
    end
    TRANSFER: begin
      miso_in = 1'b0;
      mosi_out = mosi;
      if (miso == 1'b0) begin
        next_state = RECEIVE;
      end else begin
        next_state = TRANSFER;
      end
    end
    RECEIVE: begin
      miso_in = mosi;
      mosi_out = 1'b0;
      if (ssel == 1'b1) begin
        next_state = DONE;
      end else begin
        next_state = RECEIVE;
      end
    end
    DONE: begin
      miso_in = 1'b1;
      mosi_out = 1'b0;
      next_state = IDLE;
    end
  endcase
end

// Assign the output/input of the mosi/miso signal and the ssel signal
assign mosi = mosi_out;
assign ssel = ssel_out;

endmodule