module top_module(
    input [15:0] input_num,
    output reg [3:0] ones_count
);always @(*) begin
    ones_count = (input_num & 4'h1) + ((input_num >> 1) & 4'h1) + ((input_num >> 2) & 4'h1) + ((input_num >> 3) & 4'h1) + ((input_num >> 4) & 4'h1) + ((input_num >> 5) & 4'h1) + ((input_num >> 6) & 4'h1) + ((input_num >> 7) & 4'h1) + ((input_num >> 8) & 4'h1) + ((input_num >> 9) & 4'h1) + ((input_num >> 10) & 4'h1) + ((input_num >> 11) & 4'h1) + ((input_num >> 12) & 4'h1) + ((input_num >> 13) & 4'h1) + ((input_num >> 14) & 4'h1) + ((input_num >> 15) & 4'h1);
end

endmodule