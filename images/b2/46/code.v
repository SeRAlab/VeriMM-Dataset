module reverse_bits_module(
    input wire clk,
    input wire reset,
    input wire [5:0] binary_num,
    output reg [5:0] reversed
);

    always @(posedge clk) begin
        if (reset) begin
            reversed <= 0;
        end else begin
            reversed[5] <= binary_num[0];
            reversed[4] <= binary_num[1];
            reversed[3] <= binary_num[2];
            reversed[2] <= binary_num[3];
            reversed[1] <= binary_num[4];
            reversed[0] <= binary_num[5];
        end
    end

endmodule