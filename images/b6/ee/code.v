module top_module(
    input [15:0] in0,
    input [15:0] in1,
    output reg [31:0] out
);reg [31:0] temp;
integer i, j;

always @(*) begin
    temp = 0;
    for (i = 0; i < 16; i = i + 1) begin
        if (in0[i] == 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                if (in1[j] == 1) begin
                    temp = temp + (1 << (i + j));
                end
            end
        end
    end
    out = temp;
end

endmodule