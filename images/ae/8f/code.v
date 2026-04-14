module top_module(
  input clk,
  input reset,
  input serial_in,
  output reg [7:0] data_out,
  output reg byte_received
);parameter IDLE = 2'b00;
  parameter START = 2'b01;
  parameter DATA = 2'b10;
  parameter STOP = 2'b11;

  reg [1:0] state;
  reg [3:0] count;
  reg [7:0] buffer;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      count <= 4'b0000;
      buffer <= 8'b00000000;
      byte_received <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (!serial_in) begin
            state <= START;
            count <= 4'b0001;
          end
        end
        START: begin
          if (count == 4'b1000) begin
            state <= DATA;
            count <= 4'b0000;
          end else begin
            buffer[count-1] <= serial_in;
            count <= count + 1;
          end
        end
        DATA: begin
          if (count == 4'b1000) begin
            state <= STOP;
            count <= 4'b0001;
          end else begin
            buffer[count-1] <= serial_in;
            count <= count + 1;
          end
        end
        STOP: begin
          if (count == 4'b0001) begin
            if (serial_in) begin
              data_out <= buffer;
              byte_received <= 1'b1;
              state <= IDLE;
              count <= 4'b0000;
              buffer <= 8'b00000000;
            end else begin
              state <= STOP;
              count <= 4'b0001;
            end
          end else begin
            state <= STOP;
            count <= count + 1;
          end
        end
      endcase
    end
  end

endmodule