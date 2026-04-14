module barrel_shifter (
    input [1:0] in,      // 2-bit input
    input dir,           // direction: 0 for left, 1 for right
    output reg [1:0] out // 2-bit output
);
    always @(*) begin
        if (dir == 0) begin // left shift
            out = {in[0], in[1]}; // 00 becomes 00, 01 becomes 10, 10 becomes 11, 11 becomes 00
        end else begin // right shift
            out = {in[1], in[0]}; // 00 becomes 00, 01 becomes 10, 10 becomes 11, 11 becomes 00
        end
    end
endmodule