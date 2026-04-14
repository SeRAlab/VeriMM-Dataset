module top_module(
  input clk,
  input reset,
  input [7:0] data,
  output reg detected,
  output reg [1:0] index
);// Define the four states of the FSM
  parameter IDLE = 2'b00;
  parameter BYTE1 = 2'b01;
  parameter BYTE2 = 2'b10;
  parameter BYTE3 = 2'b11;

  // Define the sequence to detect
  parameter [31:0] SEQ = 32'h12345678;

  // Define the flip-flops for the current state and the detected sequence
  reg [1:0] state;
  reg [31:0] seq_reg;

  always @(posedge clk) begin
    if (reset) begin
      // Reset the FSM and the detected signal
      state <= IDLE;
      seq_reg <= 0;
      detected <= 0;
      index <= 0;
    end else begin
      // Update the current state based on the input data
      case (state)
        IDLE: begin
          seq_reg <= {seq_reg[23:0], data};
          if (seq_reg == SEQ) begin
            detected <= 1;
            index <= 0;
            state <= IDLE;
          end else begin
            detected <= 0;
            index <= 0;
            state <= BYTE1;
          end
        end
        BYTE1: begin
          seq_reg <= {seq_reg[23:0], data};
          if (seq_reg == SEQ) begin
            detected <= 1;
            index <= 1;
            state <= IDLE;
          end else begin
            detected <= 0;
            index <= 0;
            state <= BYTE2;
          end
        end
        BYTE2: begin
          seq_reg <= {seq_reg[23:0], data};
          if (seq_reg == SEQ) begin
            detected <= 1;
            index <= 2;
            state <= IDLE;
          end else begin
            detected <= 0;
            index <= 0;
            state <= BYTE3;
          end
        end
        BYTE3: begin
          seq_reg <= {seq_reg[23:0], data};
          if (seq_reg == SEQ) begin
            detected <= 1;
            index <= 3;
            state <= IDLE;
          end else begin
            detected <= 0;
            index <= 0;
            state <= BYTE1;
          end
        end
      endcase
    end
  end

endmodule