module flash_memory_cell (
    input wire clk,
    input wire wen,
    input wire din,
    output reg dout
);
    always @(posedge clk) begin
        if (wen)
            dout <= din;
    end
endmodule