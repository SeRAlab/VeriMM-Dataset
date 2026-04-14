module sram_cell (
    input wire [7:0] D,
    input wire RE,
    input wire WE,
    output reg [7:0] Q
);
    
    reg [7:0] mem;

    always @(posedge WE or posedge RE) begin
        if (WE) begin
            mem <= D; // Write data to SRAM
        end
    end

    always @(posedge RE) begin
        if (RE) begin
            Q <= mem; // Read data from SRAM
        end
    end
endmodule