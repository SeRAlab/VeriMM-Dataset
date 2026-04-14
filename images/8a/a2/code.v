module top_module(
    input [3:0] bin,
    input clr,
    output reg [3:0] gray
);always @ (bin, clr) begin
        if (clr == 1'b0) begin
            gray <= 4'b0000;
        end
        else begin
            gray[0] = bin[0];
            gray[1] = bin[0] ^ bin[1];
            gray[2] = bin[1] ^ bin[2];
            gray[3] = bin[2] ^ bin[3];
        end
    end

endmodule