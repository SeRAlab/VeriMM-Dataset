module top_module(
    input [7:0] in, // 8-bit input for priority encoder
    input a, // First input for AND gate
    input b, // Second input for AND gate
    output reg out, // Output of the functional module
    output reg [2:0] pos // Output of the priority encoder
);// Priority Encoder
wire [7:0] in_not;
assign in_not = ~in;
wire [7:0] in_not_plus_one;
assign in_not_plus_one = in_not + 1;
wire [7:0] in_and_not_plus_one;
assign in_and_not_plus_one = in & in_not_plus_one;
wire [3:0] pos_temp;
assign pos_temp = {in_and_not_plus_one[3], in_and_not_plus_one[2], in_and_not_plus_one[1], in_and_not_plus_one[0]};
wire [3:0] pos_temp_not;
assign pos_temp_not = ~pos_temp;
wire [3:0] pos_temp_not_plus_one;
assign pos_temp_not_plus_one = pos_temp_not + 1;
assign pos = pos_temp_not_plus_one[2:0];

// AND Gate
always @ (a, b) begin
    if (a & b) begin
        out = 1;
    end
    else begin
        out = 0;
    end
end

endmodule