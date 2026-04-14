module top_module (
  input clk,
  input load,
  input [127:0] data,
  output reg [127:0] q);

always @(posedge clk) begin
    if (load)
        q <= data;
    else begin
        q <= {q[$bits(q)-1:1] ^ {q[$bits(q)-2:0], 1'b0}, 1'b0};
    end
end
endmodule