module sram_cell (
    input wire clk,
    input wire we,           // Write Enable
    input wire [15:0] din,  // Data Input
    output reg [15:0] dout   // Data Output
);
    reg [15:0] memory;       // 16-bit memory storage

    always @(posedge clk) begin
        if (we) begin
            memory <= din;    // Write operation
        end
    end

    always @(*) begin
        dout = memory;        // Read operation
    end
endmodule