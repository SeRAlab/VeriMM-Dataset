module top_module( input clk, input d, output q );reg [2:0] register;
  wire select;

  // D flip-flops
  always @(posedge clk) begin
    register <= {register[1:0], d};
  end

  // Multiplexer
  assign select = (register == 3'b000) ? 1'b0 :
                  (register == 3'b001) ? 1'b0 :
                  (register == 3'b010) ? 1'b0 :
                  (register == 3'b011) ? 1'b1 :
                  (register == 3'b100) ? 1'b0 :
                  (register == 3'b101) ? 1'b1 :
                  (register == 3'b110) ? 1'b1 :
                  (register == 3'b111) ? 1'b1 : 1'b0;

  assign q = select ? register[2] : (select ? register[1] : register[0]);
endmodule