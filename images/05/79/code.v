module SRAM_Cell (
    input [7:0] D,
    input WE,
    input RE,
    output reg [7:0] Q
);
    reg [7:0] memory;

    always @ (posedge WE or posedge RE) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
    end

    always @ (posedge RE) begin
        if (RE) begin
            Q <= memory; // Read data from memory
        end
    end
endmodule