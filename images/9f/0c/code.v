module top_module(
    input [31:0] in,
    output reg [5:0] out
);reg [31:0] temp;
integer i;

always @(*) begin
    temp = in;
    out = 6'b0;
    for (i = 0; i < 32; i = i + 1) begin
        if (temp[i])
            out = out + 1;
    end
end

endmodule