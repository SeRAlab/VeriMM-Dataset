module top_module(
  input  wire       clk,
  input  wire [2:0] in,
  output reg        out
);reg [2:0] count;
  reg [2:0] max_count;
  reg        max_input;

  always @(posedge clk) begin
    count <= {in[0], in[1], in[2]};
    if (count > max_count) begin
      max_count <= count;
      max_input <= 0;
    end
    if (count == max_count && in[0] > in[max_input]) begin
      max_input <= 0;
    end
    if (count == max_count && in[1] > in[max_input]) begin
      max_input <= 1;
    end
    if (count == max_count && in[2] > in[max_input]) begin
      max_input <= 2;
    end
  end

  always @(posedge clk) begin
    out <= in[max_input];
  end

endmodule