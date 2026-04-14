module top_module(input clk, input d, output q);reg [2:0] reg_data;
  reg [2:0] next_data;

  always @(posedge clk) begin
    next_data[0] = d;
    next_data[1] = reg_data[0];
    next_data[2] = reg_data[1];
    reg_data <= next_data;
  end

  assign q = reg_data[2];
endmodule