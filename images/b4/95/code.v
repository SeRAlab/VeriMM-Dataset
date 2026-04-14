module top_module(
  input clk,
  input reset,
  input enable,
  output reg [3:0] count
);// Define states
  parameter [1:0] S0 = 2'b00;
  parameter [1:0] S1 = 2'b01;
  parameter [1:0] S2 = 2'b10;
  parameter [1:0] S3 = 2'b11;

  // Define outputs
  localparam [3:0] COUNT_MAX = 4'b1111;
  reg [3:0] next_count;

  // Define state register and next state logic
  reg [1:0] current_state;
  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      current_state <= S0;
      next_count <= 4'b0000;
    end
    else begin
      case (current_state)
        S0: begin
          if (enable) begin
            current_state <= S1;
            next_count <= 4'b0001;
          end
        end
        S1: begin
          if (enable) begin
            current_state <= S2;
            next_count <= 4'b0010;
          end
        end
        S2: begin
          if (enable) begin
            current_state <= S3;
            next_count <= 4'b0011;
          end
        end
        S3: begin
          if (enable) begin
            current_state <= S0;
            next_count <= 4'b0000;
          end
        end
      endcase
    end
  end

  // Define output register and output logic
  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      count <= 4'b0000;
    end
    else begin
      if (current_state == S3 && next_count == COUNT_MAX) begin
        count <= 4'b0000;
      end
      else if (enable) begin
        count <= next_count;
      end
    end
  end

endmodule