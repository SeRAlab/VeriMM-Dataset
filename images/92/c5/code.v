module top_module(
    output reg comp1,
    input [4:0] v1_reg_0
);wire [4:0] sum;
  
  // Implementing simple addition logic instead of CARRY4
  assign sum = v1_reg_0 + 5'b00001;  // Example addition logic

  // Comparing the values
  always @(*) begin
    if (sum[4] == 1'b1) 
      comp1 = 1'b1;
    else 
      comp1 = 1'b0;
  end

endmodule