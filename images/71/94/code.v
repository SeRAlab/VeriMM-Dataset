module top_module(
  input rst,
  input clk,
  input ss_in,
  input data_in,
  output ss_out,
  output data_out
);// Define the states of the state machine
  parameter IDLE = 2'b00;
  parameter ACTIVE = 2'b01;
  
  // Define the signals used in the state machine
  reg [1:0] state;
  reg sclk;
  reg mosi;
  reg miso;
  reg [7:0] data;
  reg [2:0] bit_count;
  
  // Assign the outputs
  assign ss_out = state == ACTIVE ? ss_in : 1'b1;
  assign data_out = state == ACTIVE ? miso : 1'bx;
  
  // Define the clock generator
  always @(posedge clk) begin
    sclk <= ~sclk;
  end
  
  // Define the state machine
  always @(posedge clk) begin
    if (rst) begin
      state <= IDLE;
      sclk <= 1'b0;
      mosi <= 1'b0;
      miso <= 1'bx;
      data <= 8'h00;
      bit_count <= 3'b000;
    end else begin
      case (state)
        IDLE: begin
          if (!ss_in) begin
            state <= ACTIVE;
            sclk <= 1'b0;
            mosi <= data_in;
            miso <= 1'bx;
            data <= 8'h00;
            bit_count <= 3'b000;
          end
        end
        ACTIVE: begin
          sclk <= ~sclk;
          if (sclk) begin
            mosi <= data[7];
            miso <= miso | (ss_in & data_in & (1 << bit_count));
            data <= {data[6:0], data_in};
            bit_count <= bit_count + 1;
            if (bit_count == 3'b111) begin
              state <= IDLE;
            end
          end
        end
      endcase
    end
  end
  
endmodule