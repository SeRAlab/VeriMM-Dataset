module top_module(
  input ir_signal,
  output reg [7:0] command
);parameter DATA_SIZE = 8; // number of bits in the command signal

reg [DATA_SIZE-1:0] data; // data received from IR signal
reg [3:0] state; // state machine state
reg [3:0] bit_count; // bit counter
reg [15:0] timer; // timer for decoding IR signal

parameter IDLE = 4'b0000;
parameter START_BIT = 4'b0001;
parameter DATA_BIT = 4'b0010;
parameter STOP_BIT = 4'b0011;

parameter BIT_TIME = 16'd1000; // time for one bit in IR signal
parameter START_TIME = 16'd2000; // time for start bit in IR signal
parameter STOP_TIME = 16'd3000; // time for stop bit in IR signal

always @(posedge ir_signal) begin
  case (state)
    IDLE: begin
      if (!ir_signal) begin
        state <= START_BIT;
        timer <= START_TIME;
        bit_count <= 0;
      end
    end
    START_BIT: begin
      if (ir_signal) begin
        state <= IDLE;
      end else if (timer == 0) begin
        state <= DATA_BIT;
        timer <= BIT_TIME;
      end
    end
    DATA_BIT: begin
      if (ir_signal) begin
        data[bit_count] <= 1;
      end else begin
        data[bit_count] <= 0;
      end
      bit_count <= bit_count + 1;
      if (bit_count == DATA_SIZE-1) begin
        state <= STOP_BIT;
        timer <= STOP_TIME;
      end else begin
        timer <= BIT_TIME;
      end
    end
    STOP_BIT: begin
      if (ir_signal) begin
        state <= IDLE;
        command <= data;
      end else if (timer == 0) begin
        state <= START_BIT;
        timer <= START_TIME;
        bit_count <= 0;
      end
    end
  endcase
end

endmodule