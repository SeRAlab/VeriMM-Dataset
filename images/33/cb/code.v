module dram_cell (
    input wire [7:0] D,
    input wire [2:0] A, // Row address
    input wire [2:0] B, // Column address
    input wire RW, // Read/Write control
    input wire CLK,
    output reg [7:0] Q
);
    reg [7:0] mem [0:7]; // 8-bit storage for 8 addresses

    always @(posedge CLK) begin
        if (RW) begin
            mem[{A, B}] <= D; // Write operation
        end else begin
            Q <= mem[{A, B}]; // Read operation
        end
    end
endmodule