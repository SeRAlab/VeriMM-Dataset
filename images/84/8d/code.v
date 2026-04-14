module top_module(clock, reset, enable, taken_i, prediction_o);input clock, reset, enable, taken_i;
  output reg [1:0] prediction_o;

  reg [1:0] state;
  reg [1:0] next_state;

  // State encoding
  parameter S0 = 2'b00; // Strongly Not Taken
  parameter S1 = 2'b01; // Weakly Not Taken
  parameter S2 = 2'b10; // Weakly Taken
  parameter S3 = 2'b11; // Strongly Taken

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      state <= S0; // Reset to initial state
    end else if (enable) begin
      state <= next_state; // Update state
    end
  end

  always @(*) begin
    case (state)
      S0: next_state = taken_i ? S1 : S0;
      S1: next_state = taken_i ? S2 : S0;
      S2: next_state = taken_i ? S3 : S1;
      S3: next_state = taken_i ? S3 : S2;
      default: next_state = S0; // Default case
    endcase
  end

  always @(*) begin
    case (state)
      S0: prediction_o = 2'b00; // Not Taken
      S1: prediction_o = 2'b01; // Not Taken
      S2: prediction_o = 2'b10; // Taken
      S3: prediction_o = 2'b11; // Taken
      default: prediction_o = 2'b00; // Default case
    endcase
  end

endmodule