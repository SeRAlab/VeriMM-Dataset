module top_module(input I0, I1, input [3:0] INIT, output reg O);always @(*) begin
    case({I1, I0})
      2'b00: O = INIT[0];
      2'b01: O = INIT[1];
      2'b10: O = INIT[2];
      2'b11: O = INIT[3];
    endcase
  end

endmodule