module binary_counter_8bit_sync_load (
  input clk,
  input load,
  input enable,
  input [7:0] data,
  output reg [7:0] count
);

  always @(posedge clk) begin
    if (load) begin
      count <= data;
    end
    else if (enable) begin
      count <= count + 1'b1;
    end
  end

endmodule