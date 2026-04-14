module top_module(
  input clk,
  input [1:0] currentState,
  output reg [1:0] nextState
);// Power-on reset
reg [2:0] count; // Declare count as a register
initial begin
  nextState <= 2'b00; // Red state
  count <= 0; // Initialize count to 0
end

// Define state transitions
always @(posedge clk) begin
  case (currentState)
    2'b00: // Red state
      if (count == 10) begin
        nextState <= 2'b10; // Green state
        count <= 0;
      end else begin
        count <= count + 1;
      end
    2'b10: // Green state
      if (count == 5) begin
        nextState <= 2'b01; // Yellow state
        count <= 0;
      end else begin
        count <= count + 1;
      end
    2'b01: // Yellow state
      if (count == 2) begin
        nextState <= 2'b00; // Red state
        count <= 0;
      end else begin
        count <= count + 1;
      end
    default: nextState <= 2'b00; // Red state
  endcase
end

parameter CLK_PERIOD = 10; // Clock period in ns
reg clk_reg; // Internal clock register
initial begin
  clk_reg = 0; // Initialize clock
end

// Clock generation
always #(CLK_PERIOD/2) clk_reg = ~clk_reg; // Toggle clock signal 

// Use clk_reg for clock operations in the always block
assign clk = clk_reg;

endmodule