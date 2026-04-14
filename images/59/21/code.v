module top_module(input in, output reg [1:0] out);always @(in)
    begin
        out = in;
        out = out + in;
    end

endmodule