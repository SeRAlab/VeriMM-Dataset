module bin_to_gray_3bit(bin, gray);

    input [2:0] bin;
    output reg [2:0] gray;

    always @(*)
        begin
            gray[2] = bin[2];
            gray[1] = bin[2] ^ bin[1];
            gray[0] = bin[1] ^ bin[0];
        end  

endmodule