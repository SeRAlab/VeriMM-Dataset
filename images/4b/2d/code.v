module top_module(
    input wire clk,
    input wire [7:0] bin,
    output reg [7:0] gray // Change wire to reg
);always @(posedge clk) begin
        gray[0] <= bin[0];
        gray[1] <= bin[0] ^ bin[1];
        gray[2] <= bin[1] ^ bin[2];
        gray[3] <= bin[2] ^ bin[3];
        gray[4] <= bin[3] ^ bin[4];
        gray[5] <= bin[4] ^ bin[5];
        gray[6] <= bin[5] ^ bin[6];
        gray[7] <= bin[6] ^ bin[7];
    end

endmodule