module top_module(
  input clk,
  input reset,
  input [1:0] input_bits,
  output reg output_bit
);reg [1:0] state;

  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00; // reset state is S0
      output_bit <= 1'b0;
    end else begin
      case (state)
        2'b00: begin // S0 state
          if (input_bits == 2'b00) begin
            state <= 2'b00;
            output_bit <= 1'b0;
          end else if (input_bits == 2'b01) begin
            state <= 2'b01;
            output_bit <= 1'b0;
          end else if (input_bits == 2'b10) begin
            state <= 2'b10;
            output_bit <= 1'b0;
          end else begin // input_bits == 2'b11
            state <= 2'b00;
            output_bit <= 1'b0;
          end
        end
        2'b01: begin // S1 state
          if (input_bits == 2'b00) begin
            state <= 2'b01;
            output_bit <= 1'b1;
          end else if (input_bits == 2'b01) begin
            state <= 2'b10;
            output_bit <= 1'b1;
          end else if (input_bits == 2'b10) begin
            state <= 2'b00;
            output_bit <= 1'b1;
          end else begin // input_bits == 2'b11
            state <= 2'b01;
            output_bit <= 1'b1;
          end
        end
        2'b10: begin // S2 state
          if (input_bits == 2'b00) begin
            state <= 2'b10;
            output_bit <= 1'b0;
          end else if (input_bits == 2'b01) begin
            state <= 2'b00;
            output_bit <= 1'b0;
          end else if (input_bits == 2'b10) begin
            state <= 2'b01;
            output_bit <= 1'b0;
          end else begin // input_bits == 2'b11
            state <= 2'b10;
            output_bit <= 1'b0;
          end
        end
      endcase
    end
  end

endmodule