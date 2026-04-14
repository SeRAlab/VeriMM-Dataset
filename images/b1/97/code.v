module top_module(
    input [15:0] in,
    output reg [3:0] ones_count
);integer i;
    always @(*) begin
        ones_count = 0;
        for (i = 0; i < 16; i = i + 1) begin
            if (in[i] == 1'b1) begin
                ones_count = ones_count + 1;
            end
        end
    end
endmodule