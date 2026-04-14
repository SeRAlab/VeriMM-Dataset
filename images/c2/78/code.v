module shift_register(clk, reset, serial_in, parallel_out);
  input clk, reset, serial_in;
  output [3:0] parallel_out;

  reg [3:0] register;

  always @(posedge clk) begin
    if (reset) begin
      register <= 4'b0;
    end else begin
      register <= {register[2:0], serial_in};
    end
  end

  always @(negedge clk) begin
    parallel_out <= register;
  end
endmodule