module register_4bit(
    input wire [3:0] D,
    input wire clk,
    input wire rst,
    output reg [3:0] Q
    );

always @(posedge clk) begin
    if (rst)
        Q <= 4'b0000;
    else
        Q <= D;
end

endmodule