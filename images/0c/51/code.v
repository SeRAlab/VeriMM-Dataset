module sram_cell (
    input wire WE,
    input wire RE,
    input wire SET,
    input wire RESET,
    input wire D,
    output reg Q
);
    always @(posedge SET or posedge RESET or posedge WE) begin
        if (SET) begin
            Q <= 1'b1;
        end else if (RESET) begin
            Q <= 1'b0;
        end else if (WE) begin
            Q <= D;
        end
    end

    always @(posedge RE) begin
        // Q outputs the stored value when read is enabled
        // No need to change Q here as it is already updated on WE or SET/RESET
    end
endmodule