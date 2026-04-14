module top_module(
  input clk,
  input rst,
  input mosi,
  output reg miso,  // Change to reg type
  output reg cs,    // Change to reg type
  output reg sclk    // Change to reg type
);// Define the state machine states
  parameter IDLE = 2'b00;
  parameter TRANSMIT = 2'b01;
  parameter RECEIVE = 2'b10;
  parameter DONE = 2'b11;

  // Define the state machine inputs
  reg [1:0] state;
  reg cs_enable;
  reg mosi_data;
  wire miso_data;  // Assuming miso_data needs to be assigned somehow

  // Define the state machine outputs
  reg sclk_enable;

  // Define the state machine registers
  reg [7:0] tx_data;
  reg [7:0] rx_data;
  reg [2:0] bit_count;

  // Define the state machine always block
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      cs <= 1'b1;       // Reset CS to inactive
      cs_enable <= 1'b0;
      mosi_data <= 1'b0;
      sclk_enable <= 1'b0;
      tx_data <= 8'h00;
      rx_data <= 8'h00;
      bit_count <= 3'd0;
    end else begin
      case (state)
        IDLE: begin
          if (cs_enable) begin
            state <= TRANSMIT;
            cs <= 1'b0;  // Active low chip select
            sclk_enable <= 1'b1;
          end
        end
        TRANSMIT: begin
          if (sclk_enable) begin
            mosi_data <= tx_data[7];
            tx_data <= {tx_data[6:0], 1'b0};
            bit_count <= bit_count + 1;
            if (bit_count == 3'd7) begin  // Change condition to 3'd7
              state <= RECEIVE;
              bit_count <= 3'd0;
            end
          end
        end
        RECEIVE: begin
          if (sclk_enable) begin
            rx_data <= {miso_data, rx_data[7:1]};
            bit_count <= bit_count + 1;
            if (bit_count == 3'd7) begin  // Change condition to 3'd7
              state <= DONE;
              bit_count <= 3'd0;
            end
          end
        end
        DONE: begin
          cs <= 1'b1;  // Deactivate chip select
          sclk_enable <= 1'b0;
          if (!cs_enable) begin
            state <= IDLE;
          end
        end
      endcase
    end
  end

  // Define the input and output assignments
  assign miso = mosi_data;  // Update assuming miso_data is mosi_data instead

endmodule