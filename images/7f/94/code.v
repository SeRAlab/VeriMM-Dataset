module top_module(
    input [15:0] num,
    output reg [3:0] ones_count // Change output to reg type
);integer i;
reg [15:0] temp;

always @(*) begin
    ones_count = 0;
    temp = num;
    for (i = 0; i < 16; i = i + 1) begin
        ones_count = ones_count + temp[0];
        temp = temp >> 1;
    end
end

endmodule