module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  input [31:0] data_len,
  output reg [15:0] checksum,
  output reg valid
);// Define constants
  parameter PRIME = 65521;
  parameter BLOCK_SIZE = 16;

  // Define state machine states
  localparam IDLE = 0;
  localparam PROCESSING = 1;
  localparam CHECKSUM = 2;

  // Define state machine variables
  reg [31:0] byte_count;
  reg [15:0] rolling_sum;
  reg [15:0] block_sum;
  reg [1:0] state;

  // Declare internal signals
  reg [7:0] data_in_reg; // Change from wire to reg
  reg [15:0] checksum_reg;

  // Register input data on clock edge
  always @(posedge clk) begin
    if (reset) begin
      data_in_reg <= 0;
    end else begin
      data_in_reg <= data_in;
    end
  end

  // State machine
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      byte_count <= 0;
      rolling_sum <= 1;
      block_sum <= 0;
      checksum <= 0;
      valid <= 0;
    end else begin
      case (state)
        IDLE: begin
          // Wait for data to be valid
          if (data_len > 0) begin
            state <= PROCESSING;
          end
        end
        PROCESSING: begin
          // Add byte to rolling sum
          rolling_sum <= (rolling_sum + data_in_reg) % PRIME;
          block_sum <= (block_sum + data_in_reg) % PRIME;
          byte_count <= byte_count + 1;

          // Check if block is complete
          if (byte_count == BLOCK_SIZE || byte_count == data_len) begin
            state <= CHECKSUM;
          end
        end
        CHECKSUM: begin
          // Calculate final checksum
          checksum_reg <= (block_sum << 16) + rolling_sum;
          if (checksum_reg == checksum) begin
            valid <= 1;
          end else begin
            valid <= 0;
          end

          // Reset state machine
          byte_count <= 0;
          rolling_sum <= 1;
          block_sum <= 0;
          checksum <= checksum_reg;
          state <= IDLE;
        end
      endcase
    end
  end

endmodule