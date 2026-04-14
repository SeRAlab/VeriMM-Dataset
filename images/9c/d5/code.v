module top_module(input D, input C, input reset, input set, output reg Q);always @(posedge C or posedge reset or posedge set) begin
    if (reset) begin
      Q <= 0;
    end else if (set) begin
      Q <= 1;
    end else begin
      Q <= D;
    end
  end
endmodule