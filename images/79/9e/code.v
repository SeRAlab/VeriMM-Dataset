module top_module(
  input clk,
  input reset,
  input data,
  input enable,
  output reg match
);// Define the four states using one-hot encoding
parameter A = 4'b0001;
parameter B = 4'b0010;
parameter C = 4'b0100;
parameter D = 4'b1000;

// Define the state register and initialize it to state A
reg [3:0] state_reg = A;

// Define the output register and initialize it to 0
reg output_reg = 1'b0;

// State transition and output logic equations
always @ (posedge clk) begin
  if (reset) begin
    state_reg <= A;
    output_reg <= 1'b0;
  end
  else if (enable) begin
    case (state_reg)
      A: begin
        if (data) state_reg <= B;
        else state_reg <= A;
      end
      B: begin
        if (!data) state_reg <= C;
        else state_reg <= B;
      end
      C: begin
        if (data) state_reg <= D;
        else state_reg <= A;
      end
      D: begin
        if (!data) begin
          state_reg <= A;
          output_reg <= 1'b1;
        end
        else state_reg <= B;
      end
    endcase
  end
end

// Assign the output to the output register
assign match = output_reg;

endmodule