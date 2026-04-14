module top_module(
  input clk,
  input reset,
  input load_data,
  input [31:0] in_data,
  output reg [31:0] shift_out,
  output reg [31:0] parallel_out
);reg [31:0] register;

  always @(posedge clk) begin
    if (reset) begin
      register <= 32'b0;
    end else if (load_data) begin
      register <= in_data;
    end else begin
      register <= {register[30:0], register[31]};
    end
  end

  assign shift_out = register;
  assign parallel_out = load_data ? in_data : register;

endmodule