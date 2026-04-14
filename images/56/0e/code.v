module verified_binary_to_gray(bin, gray);  

    input [1:0] bin;  
    output [1:0] gray;  
    reg [1:0] gray;

    always @(*)
        begin
            gray[1] = bin[1];
            gray[0] = bin[1] ^ bin[0];
        end  

endmodule