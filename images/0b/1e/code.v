module SRAM_Cell (
    input wire [3:0] Din,
    output reg [3:0] Dout,
    input wire WE,
    input wire clk
);
    reg [3:0] mem;

    always @(posedge clk) begin
        if (WE) begin
            mem <= Din;
        end
        Dout <= mem;
    end
endmodule