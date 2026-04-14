module top_module(
  input wire clk,
  input wire reset,
  input wire [width-1:0] data_in,
  output reg [width-1:0] data_out
);parameter width = 8; // width of the data signal

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 0;
    end else begin
        data_out <= data_in;
    end
end

endmodule