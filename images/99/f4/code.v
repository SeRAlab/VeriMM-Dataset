module top_module(
  input clk,
  input rst,
  input [7:0] data_in,
  input valid_in,
  output valid_out,
  output reg [15:0] checksum
);// parameter declaration
  parameter N = 65521; // largest prime number less than 2^16
  
  // internal registers
  reg [15:0] s1 = 1;
  reg [15:0] s2 = 0;
  
  // state machine
  reg [1:0] state = 0;
  parameter IDLE = 2'b00;
  parameter PROCESS = 2'b01;
  parameter OUTPUT = 2'b10;
  
  // combinational logic
  assign valid_out = (state == OUTPUT);
  
  // sequential logic
  always @(posedge clk) begin
    if (rst) begin
      s1 <= 1;
      s2 <= 0;
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          if (valid_in) begin
            s1 <= data_in;
            s2 <= data_in;
            state <= PROCESS;
          end
        end
        PROCESS: begin
          if (valid_in) begin
            s1 <= (s1 + data_in) % N;
            s2 <= (s2 + s1) % N;
          end else begin
            state <= OUTPUT;
          end
        end
        OUTPUT: begin
          checksum <= (s2 << 16) | s1;
          state <= IDLE;
        end
      endcase
    end
  end

endmodule