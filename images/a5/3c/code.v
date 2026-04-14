module top_module(
  input clk,
  input reset,
  input data,
  input pulse_width,
  output reg pulse,
  output reg flag
);reg data_prev;
reg [31:0] counter;

always @(posedge clk, posedge reset) begin
  if(reset) begin
    data_prev <= 1'b0;
    counter <= 0;
    pulse <= 1'b0;
    flag <= 1'b0;
  end else begin
    if(data == 1'b1 && data_prev == 1'b0) begin
      counter <= pulse_width - 1;
      pulse <= 1'b1;
      flag <= 1'b1;
    end else if(counter > 0) begin
      counter <= counter - 1;
      pulse <= 1'b1;
      flag <= 1'b0;
    end else begin
      pulse <= 1'b0;
      flag <= 1'b0;
    end
    data_prev <= data;
  end
end

endmodule