module add_sub_4bit (
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  input ctrl,
  output [3:0] result
);

  reg [3:0] temp_result;
  
  always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      temp_result <= 4'b0000;
    end else begin
      if (ctrl == 0) begin
        temp_result <= A + B;
      end else begin
        temp_result <= A - B;
      end
    end
  end
  
  assign result = temp_result;

endmodule
