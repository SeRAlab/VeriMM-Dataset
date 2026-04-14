module counter (
    input clk,
    input en,
    output reg [3:0] out
);

always @(posedge clk)
begin
    if (en)
        out <= out + 1;
end

endmodule