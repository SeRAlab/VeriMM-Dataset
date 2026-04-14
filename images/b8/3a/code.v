module top_module( input clk, input d, output q );reg [2:0] reg_data;
  reg [1:0] sel;

  always @(posedge clk) begin
    reg_data <= {reg_data[1:0], d};
    sel <= sel + 1;
  end

  assign q = reg_data[sel];

endmodule