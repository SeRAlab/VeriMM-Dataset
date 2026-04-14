module SRAM_Cell (
    input wire [3:0] D,
    input wire WE,
    output reg [3:0] Q
);
    always @(posedge WE) begin
        Q <= D; // Write data to SRAM when WE is high
    end

    always @(negedge WE) begin
        // When WE is low, output the stored data
        Q <= Q; 
    end
endmodule