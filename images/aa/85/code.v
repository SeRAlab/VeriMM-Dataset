module top_module(
  input logic [3:0] in_signal,
  input logic reset,
  output logic [2:0] out_signal
);parameter const_value = 4'b1010; // Define constant value

  always_comb begin
    if(reset) begin // Reset output signal to 0 when reset is high
      out_signal = 3'b0;
    end else begin // Add input signal with constant value
      out_signal = in_signal + const_value[3:1];
    end
  end

endmodule