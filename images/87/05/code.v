module top_module(
  input [31:0] in1, // memory address
  input in2, // write enable signal
  output reg out // changing 'out' to output reg type
);parameter [31:0] start_address = 32'h00000000; // starting address of the memory region to be protected
parameter [31:0] end_address = 32'h000000ff; // ending address of the memory region to be protected
parameter write_enable = 1'b0; // write access not allowed to the protected memory region

always @(*) begin
  if (in1 >= start_address && in1 <= end_address && write_enable == 1'b0 && in2 == 1'b1) begin
    out = 1'b1; // memory region is protected and write access is not allowed
  end else begin
    out = 1'b0; // memory region is not protected or write access is allowed
  end
end

endmodule