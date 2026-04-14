module debouncer(
  input clk,
  input rst_n,
  input noisy_in,
  output reg clean_out
);

  reg [15:0] counter;
  parameter MAX_COUNT = 16'hFFFF;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      counter <= 16'b0;
      clean_out <= 1'b0;
    end else begin
      if (noisy_in) begin
        if (counter == MAX_COUNT) begin
          clean_out <= 1'b1;
        end else begin
          counter <= counter + 1;
        end
      end else begin
        counter <= 16'b0;
        clean_out <= 1'b0;
      end
    end
  end

endmodule