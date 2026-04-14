module top_module(
    input [15:0] data_in,
    output reg [7:0] ones_out
);integer i;
    reg [3:0] count;

    always @(*) begin
        count = 0;
        for (i = 0; i < 16; i = i + 1) begin
            if (data_in[i] == 1'b1) begin
                count = count + 1;
            end
        end
        ones_out = count;
    end

endmodule