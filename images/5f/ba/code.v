module top_module(
  input [127:0] data,
  output reg [7:0] count
);integer i;
  always @ (data) begin
    count = 0;
    for (i = 0; i < 128; i = i + 1) begin
      if (data[i] == 1'b0) begin
        count = count + 1;
      end
    end
  end

endmodule