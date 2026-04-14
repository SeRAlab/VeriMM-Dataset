module top_module(input clk, reset, data, output q);reg [2:0] reg_data;
  reg [2:0] next_data;
  reg q_out;

  always @ (posedge clk) begin
    if (reset) begin
      reg_data <= 3'b0;
      q_out <= 1'b0;
    end else begin
      reg_data <= next_data;
      q_out <= reg_data[2];
    end
  end

  always @ (*) begin
    next_data[0] = data;
    next_data[1] = reg_data[0];
    next_data[2] = reg_data[1];
  end

  assign q = q_out;
endmodule