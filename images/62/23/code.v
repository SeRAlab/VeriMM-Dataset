module top_module(IN, OUT);parameter WIDTH = 0;

    input [WIDTH-1:0] IN;
    output reg OUT;

    integer i;

    always @(*) begin
        OUT = 0;
        for (i = 0; i < WIDTH; i=i+1) begin
            OUT = OUT | IN[i];
        end
    end
endmodule