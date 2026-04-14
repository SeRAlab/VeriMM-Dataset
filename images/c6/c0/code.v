module max32 (in1, out1);
input [31:0] in1;
output [31:0] out1;

reg [31:0] max_val;

always @ (in1) begin
    if (in1 > max_val) begin
        max_val <= in1;
    end
end

assign out1 = max_val;

endmodule