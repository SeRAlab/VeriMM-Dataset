module top_module(
  input clk,
  input reset,
  input in0,
  input in1,
  input in2,
  input in3,
  output reg [1:0] out,  // Changed to 2 bits wide
  output reg valid
);always @(posedge clk or posedge reset) begin  // Use clock edge or reset for synchronous logic
    if (reset) begin
      out <= 2'b00;  // Set to 2 bits
      valid <= 1'b0;
    end else begin
      casez({in3, in2, in1, in0})
        4'b0001: out <= 2'b00;  // Set to 2 bits
        4'b0010: out <= 2'b01;  // Set to 2 bits
        4'b0100: out <= 2'b10;  // Set to 2 bits
        4'b1000: out <= 2'b11;  // Set to 2 bits
        default: out <= out;    // Retain the current value if no input is high
      endcase
      
      if (in0 || in1 || in2 || in3) begin
        valid <= 1'b1;
      end else begin
        valid <= 1'b0;
      end
    end
  end

endmodule