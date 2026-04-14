module sram_cell (
    input wire D,          // Data input
    input wire WE,         // Write enable
    input wire RE,         // Read enable
    output reg Q           // Data output
);
    always @(posedge WE or posedge RE) begin
        if (WE) 
            Q <= D;       // Write data to cell
        // else if (RE) 
        //     Q <= Q;     // Maintain current state when read enabled
    end
endmodule