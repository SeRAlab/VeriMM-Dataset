module Mux2 #(parameter WIDTH = 32)(
    input  sel,
    input  [(WIDTH-1):0] in0, in1,
    output [(WIDTH-1):0] out
    );
    assign out = (sel) ? in1 : in0;
endmodule