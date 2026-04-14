module register_8bit (
    input wire [7:0] D,
    input wire Clk,
    input wire Load,
    output reg [7:0] Q
    );

always @(posedge Clk) begin
    if (Load)
        Q <= D;
end

endmodule