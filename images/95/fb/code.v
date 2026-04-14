module top_module(
  input wire clk,
  input wire reset,
  input wire [15:0] input_signal,
  output reg [3:0] output_signal
);reg [3:0] count;

always @(posedge clk) begin
  if (reset) begin
    count <= 0;
  end else begin
    if (input_signal == 16'b1111_1111_1111_1111 || input_signal == 16'b0000_0000_0000_0000) begin
      count <= 0;
    end else if (input_signal[15] == 1) begin
      count <= 1;
    end else begin
      count <= count + 1;
    end
  end
end

always @(posedge clk) begin
  if (reset) begin
    output_signal <= 0;
  end else if (input_signal == 16'b1111_1111_1111_1111 || input_signal == 16'b0000_0000_0000_0000) begin
    output_signal <= 0;
  end else if (input_signal[15] == 1) begin
    output_signal <= count;
  end
end

endmodule