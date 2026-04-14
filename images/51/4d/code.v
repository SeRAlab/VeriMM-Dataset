module decoder (
    input enable,
    input [2:0] in,
    output [7:0] out );reg [7:0] out_reg;

always @(enable or in) begin
    if (enable)
        out_reg = 8'b00000001 << in;
    else
        out_reg = 8'b00000000;
end

assign out = out_reg;

endmodule