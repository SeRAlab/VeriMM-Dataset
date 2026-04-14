module top_module(
  input clk,
  input reset,
  input [7:0] data,
  input select,
  output reg [7:0] q
);reg [7:0] reg_data;
  reg xor_out;

  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      reg_data <= 8'b0;
      q <= 8'b0;
      xor_out <= 1'b0;
    end
    else begin
      if (select == 1) begin // Parallel load mode
        reg_data <= data;
        q <= reg_data;
        xor_out <= reg_data ^ data;
      end
      else begin // Shift mode
        reg_data <= {reg_data[6:0], reg_data[7]};
        q <= reg_data;
        xor_out <= reg_data[7] ^ data[0];
      end
    end
  end

endmodule