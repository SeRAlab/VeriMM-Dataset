module top_module(
  input clk,
  input reset,
  input load,
  input [5:0] data,
  output [5:0] q
);reg [5:0] reg_data;

  always @(posedge clk, negedge reset) begin
    if (!reset) begin
      reg_data <= 6'b0;
    end else begin
      if (load) begin
        reg_data <= data;
      end else begin
        reg_data <= {reg_data[4:0], reg_data[5]};
      end
    end
  end

  assign q = reg_data;

endmodule