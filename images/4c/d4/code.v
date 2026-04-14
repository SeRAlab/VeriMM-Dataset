module top_module(
  input aclk,
  input axi_rd,
  input axi_rd_busy,
  output reg out // Change output to reg type
);// Define states
  parameter IDLE = 2'b00;
  parameter BUSY = 2'b01;

  // Define state register and next state logic
  reg [1:0] state, next_state;
  always @(posedge aclk) begin
    state <= next_state;
  end

  // Define state machine logic
  always @(*) begin
    case(state)
      IDLE: begin
        if(axi_rd == 1'b0 || axi_rd_busy == 1'b0) begin
          next_state = IDLE;
          out = 1'b0;
        end else begin
          next_state = BUSY;
          out = 1'b1;
        end
      end
      BUSY: begin
        if(axi_rd_busy == 1'b1) begin
          next_state = BUSY;
          out = 1'b1;
        end else begin
          next_state = IDLE;
          out = 1'b0;
        end
      end
      default: begin
        next_state = IDLE; // Add default case for safe state transition
        out = 1'b0; // Assign a default value for out
      end
    endcase
  end

endmodule