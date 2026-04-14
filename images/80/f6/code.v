module top_module(
    input [31:0]OP,
    input [31:0]OP1,
    output reg [31:0]OPS
);always @*
begin
    OPS <= OP+OP1;
end

endmodule