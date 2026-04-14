module shift_register(clk, load, data_in, shift_en, data_out);
  input clk;
  input load;
  input [15:0] data_in;
  input shift_en;
  output [15:0] data_out;

  reg [15:0] reg_data;

  always @(posedge clk) begin
    if (load) begin
      reg_data <= data_in;
    end else if (shift_en) begin
      reg_data <= {reg_data[14:0], 1'b0};
    end
  end

  assign data_out = reg_data;

endmodule