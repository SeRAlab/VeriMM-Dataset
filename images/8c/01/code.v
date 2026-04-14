module top_module(
  input clk,
  input reset,
  input in_signal,
  output reg [1:0] state,
  output reg out_signal  // Changed output to reg
);// State encoding
  localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

  // State transition and output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= S0;
      out_signal <= 1'b0;
    end else begin
      case (state)
        S0: begin
          if (in_signal) begin
            state <= S1;
            out_signal <= 1'b0;
          end
        end
        S1: begin
          if (!in_signal) begin
            state <= S2;
            out_signal <= 1'b1;
          end
        end
        S2: begin
          if (in_signal) begin
            state <= S3;
            out_signal <= 1'b1;
          end else begin
            state <= S1;
            out_signal <= 1'b1;
          end
        end
        S3: begin
          if (!in_signal) begin
            state <= S0;
            out_signal <= 1'b0;
          end
        end
      endcase
    end
  end

endmodule