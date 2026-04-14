module binary_counter(clk, reset, load_en, data_in, count_out);
  input clk, reset, load_en;
  input [3:0] data_in;
  output reg [3:0] count_out;
  
  always @(posedge clk) begin
    if (reset) begin
      count_out <= 4'b0;
    end else if (load_en) begin
      count_out <= data_in;
    end else begin
      count_out <= count_out + 1;
    end
  end
endmodule