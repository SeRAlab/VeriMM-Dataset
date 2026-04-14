module top_module(input clk, input d, output q);reg [2:0] reg_data; // 3-bit shift register

  always @(posedge clk) begin
    reg_data <= {reg_data[1:0], d}; // shift data on each clock cycle
  end

  assign q = reg_data[0]; // output of the last flip-flop

endmodule