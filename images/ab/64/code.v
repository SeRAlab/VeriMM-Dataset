module gray_to_binary (
    input [3:0] gray,
    output reg [3:0] bin);

    integer i;
    always @(*) begin
        bin = gray;
        for (i = 1; i < 4; i = i + 1) begin
            bin[i] = bin[i] ^ bin[i-1];
        end
    end
endmodule