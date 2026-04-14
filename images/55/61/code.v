module top_module(clk, reset, serial_in, parallel_out);input clk, reset, serial_in;
  output reg [3:0] parallel_out; // Changed output to reg

  reg [3:0] register;

  always @(posedge clk) begin
    if (reset) begin
      register <= 4'b0;
      parallel_out <= 4'b0; // Also reset the output when reset is asserted
    end else begin
      register <= {register[2:0], serial_in};
      parallel_out <= register; // Update parallel_out in the same always block
    end
  end
endmodule