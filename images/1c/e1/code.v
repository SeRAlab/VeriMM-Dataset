module SRAM_1bit (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q,
    output reg VLD
);
    always @(posedge WE) begin
        if (WE) begin
            Q <= D; // Write data to SRAM
        end
    end

    always @(posedge RE) begin
        if (RE) begin
            VLD <= 1; // Data is valid when read is enabled
        end else begin
            VLD <= 0; // Data is not valid when read is disabled
        end
    end
endmodule