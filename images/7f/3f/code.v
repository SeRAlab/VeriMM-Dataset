module top_module(in, out);input   [31:0] in;
    output  [31:0] out;
    reg     [31:0] out;
    reg     [31:0] a;
    reg     [31:0] b;
    
    always @(in)
        begin : shiftleft_thread
            a = in;
            b = (a << 2);
            out = b;
        end

endmodule