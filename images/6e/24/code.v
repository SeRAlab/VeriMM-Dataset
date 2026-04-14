module top_module(
    input [15:0] num,
    output reg [3:0] count
);integer i;
    always @(*) begin
        count = 0;
        for (i = 0; i < 16; i = i + 1) begin
            if (num[i] == 1)
                count = count + 1;
        end
    end
endmodule