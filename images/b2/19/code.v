module top_module(
  input clk,
  input rst_n,
  input [7:0] input0,
  input [7:0] input1,
  input [7:0] input2,
  input [1:0] select,
  output [7:0] out
);reg [63:0] johnson_counter;
  wire [7:0] mux_out;

  // Johnson counter implementation
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      johnson_counter <= 64'b0;
    end else begin
      johnson_counter <= {johnson_counter[62:0], ~(johnson_counter[63] ^ johnson_counter[0])};
    end
  end

  // Multiplexer implementation
  assign mux_out = (select == 2'b00) ? input0 :
                   (select == 2'b01) ? input1 :
                   (select == 2'b10) ? input2 :
                   8'b0;

  // Output selection
  assign out = (johnson_counter[63]) ? mux_out : 8'b0;

endmodule