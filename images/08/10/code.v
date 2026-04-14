module flash_memory_cell (
    input wire CLK,
    input wire WE,
    input wire [7:0] DI,
    output reg [7:0] DO
);
    always @(posedge CLK) begin
        if (WE) begin
            DO <= DI;  // Write data to memory cell
        end
        // else DO retains its previous state (read operation)
    end
endmodule