module shift_reg (
  input clk,
  input reset,
  input load,
  input [3:0] data_in,
  output reg [3:0] shift_out
);

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      shift_out <= 4'b0;
    end
    else if (load) begin
      shift_out <= data_in;
    end
    else begin
      shift_out <= {shift_out[2:0], shift_out[3]};
    end
  end

endmodule
