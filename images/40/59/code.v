module dram_cell (
    input wire clk,
    input wire we,
    input wire [2:0] addr,
    input wire din,
    output reg dout
);
    reg [7:0] mem;

    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= din;
        end
        dout <= mem[addr];
    end

    initial begin
        mem = 8'b00000000;  // Initialize memory to 0
    end
endmodule