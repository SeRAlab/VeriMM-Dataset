module SRAM_Cell (
    input wire [3:0] D,
    input wire WL,
    input wire R_W,
    input wire CE,
    output reg [3:0] Q
);
    reg [3:0] memory;

    always @(posedge WL) begin
        if (!CE) begin
            if (R_W) begin
                memory <= D; // Write
            end else begin
                Q <= memory; // Read
            end
        end
    end
endmodule