module top_module(
  input clk, 
  input rst,
  input data_in,
  input data_valid,
  input rx,
  output reg data_out,
  output reg data_ready,
  output reg tx
);// Define the state machine states
  parameter IDLE = 2'b00;
  parameter TRANSMIT = 2'b01;
  parameter RECEIVE = 2'b10;
  
  // Define the state machine signals
  reg [1:0] state;
  reg [7:0] tx_data;
  reg [7:0] rx_data;
  reg tx_busy;
  reg rx_busy;
  
  // Define the data transmission and reception protocols
  always @(posedge clk) begin
    if (rst) begin
      state <= IDLE;
      tx_busy <= 0;
      rx_busy <= 0;
      tx <= 0;
      data_ready <= 0;
      data_out <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (data_valid) begin
            tx_data <= data_in;
            tx_busy <= 1;
            state <= TRANSMIT;
          end else if (rx) begin
            rx_busy <= 1;
            state <= RECEIVE;
          end
        end
        
        TRANSMIT: begin
          if (!tx_busy) begin
            tx <= 1;
            state <= IDLE;
          end
        end
        
        RECEIVE: begin
          if (!rx_busy) begin
            data_out <= rx_data;
            data_ready <= 1;
            state <= IDLE;
          end
        end
      endcase
    end
  end
  
  // Define the transmitter and receiver blocks
  always @(posedge clk) begin
    if (tx_busy) begin
      tx_data <= tx_data >> 1;
      tx <= ~tx_data[0];
      if (!tx_data[0]) begin
        tx_busy <= 0;
        tx <= 0;
      end
    end else if (rx) begin
      rx_data <= {rx_data[6:0], rx};
      rx_busy <= (rx_data == 8'hFF);
    end
  end
  
endmodule