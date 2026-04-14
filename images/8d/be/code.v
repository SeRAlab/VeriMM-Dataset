module top_module(input input_a, input [3:0] input_b, input [7:0] input_c, input [15:0] input_d, output reg output_x, output reg [3:0] output_y, output reg [7:0] output_z);always @(*)
begin
    if(input_a == 0)
        output_x = 1;
    else
        output_x = 0;
    output_y = input_b[3:0];
    output_z = input_c | input_d[7:0];
end

endmodule