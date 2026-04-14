module top_module(
  input clk,
  input rst,
  input start,
  input [7:0] key,
  input [7:0] address,
  input [7:0] data_in,
  output reg [7:0] data_out
);reg [7:0] mem [255:0];
reg [7:0] temp_data;

always @(posedge clk) begin
  if (rst) begin
    data_out <= 0;
    temp_data <= 0;
  end else begin
    if (start) begin
      if (address < 256) begin
        if (temp_data == 0) begin
          if (key[0] == 1) begin
            mem[address] <= ~data_in;
          end else begin
            mem[address] <= data_in ^ key;
          end
          temp_data <= 1;
        end else begin
          if (key[0] == 1) begin
            data_out <= ~mem[address];
          end else begin
            data_out <= mem[address] ^ key;
          end
          temp_data <= 0;
        end
      end
    end
  end
end

endmodule