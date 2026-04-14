module counter (
    input clk,
    output reg [2:0] count
);

always @(posedge clk)
begin
    if (count == 3'b111)
        count <= 3'b000;
    else
        count <= count + 1;
end

endmodule