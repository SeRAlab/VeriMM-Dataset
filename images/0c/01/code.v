module flash_memory_cell (
    input wire WE,
    input wire [7:0] D,
    output reg [7:0] Q
);
    always @(*) begin
        if (WE) begin
            Q = D; // Write data to memory cell
        end else begin
            Q = Q; // Maintain current data when WE is low
        end
    end
endmodule