module top_module(
    /* Input ports */
    input [7:0] in,
    /* Output ports */
    output reg [3:0] out
);integer i;
reg [3:0] count;

always @ (*) begin
    count = 0;
    for (i = 0; i < 8; i = i + 1) begin
        if (in[i] == 1) begin
            count = count + 1;
        end
    end
    out = count;
end

endmodule