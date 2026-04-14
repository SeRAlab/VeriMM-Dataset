module count_ones (
    input [15:0] in,
    output reg [3:0] out
);
    integer i;
    always @(*) begin
        out = 0;
        for (i = 0; i < 16; i = i + 1) begin
            if (in[i])
                out = out + 1;
        end
    end
endmodule