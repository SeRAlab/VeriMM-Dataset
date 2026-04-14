module top_module( input clk, input d, input shift, input reset, output q );reg [3:0] register;

  always @(posedge clk) begin
    if (reset) begin
      register <= 4'b0;
    end else if (shift) begin
      register <= {register[2:0], d};
    end else begin
      register <= d;
    end
  end

  assign q = register[3];
endmodule