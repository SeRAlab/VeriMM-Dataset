module reg8bit (
    input wire clk,
    input wire rst,
    input wire [7:0] d,
    output reg [7:0] q
);

always @(posedge clk)
begin
    if (rst)
        q <= 8'b00000000;
    else
        q <= d;
end

endmodule