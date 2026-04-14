module top_module(input D, input C, input E, input R, output reg Q);always @(posedge C or posedge R or posedge E)
    if (R)
      Q <= 0;
    else if (E)
      Q <= D;

endmodule