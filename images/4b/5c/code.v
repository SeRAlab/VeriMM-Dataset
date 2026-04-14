module top_module(
  input wire [31:0] in0,
  input wire [31:0] in1,
  input wire select,
  input wire enable,
  output reg [31:0] out  // Change wire to reg
);wire [31:0] mux_out;

  assign mux_out = select ? in1 : in0;

  always @ (posedge enable) begin
    if (enable) begin
      out <= mux_out;
    end else begin
      out <= 32'b0; // Specify zero explicitly for clarity
    end
  end

endmodule