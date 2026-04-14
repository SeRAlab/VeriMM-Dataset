module top_module(
  input clock, reset, enable, taken_i,
  output prediction_o
);// Define the states
  parameter PREDICT_0 = 1'b0;
  parameter PREDICT_1 = 1'b1;

  // Define the state register
  reg [0:1] state_reg;
  always @(posedge clock) begin
    if (reset) begin
      state_reg <= PREDICT_0;
    end else if (enable) begin
      case (state_reg)
        PREDICT_0: begin
          if (taken_i) begin
            state_reg <= PREDICT_1;
          end
        end
        PREDICT_1: begin
          if (!taken_i) begin
            state_reg <= PREDICT_0;
          end
        end
      endcase
    end
  end

  // Define the output
  assign prediction_o = (state_reg == PREDICT_1);

endmodule