module top_module(input D, input C, input E, output reg Q);always @(posedge C) begin
    if (E) begin
      Q <= D;
    end
  end

endmodule