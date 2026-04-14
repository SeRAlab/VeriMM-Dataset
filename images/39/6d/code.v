module sram_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D; // Store data when write enable is high
        end
    end

    always @(posedge RE) begin
        if (RE) begin
            // Output the stored value when read enable is high
            Q <= Q;
        end
    end
endmodule