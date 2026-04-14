module count_ones (
    input clk,
    input [7:0] data_in,
    output reg [3:0] count
);

    integer i;

    always @(posedge clk) begin
        count = 4'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (data_in[i]) count = count + 1;
        end
    end
endmodule