module register_8bit (
    input wire rst_n,
    input wire clk,
    input wire load,
    input wire [7:0] din,
    output reg [7:0] dout
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        dout <= 8'b00000000;
    else if (load)
        dout <= din;
end

endmodule