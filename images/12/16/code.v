module sram_1bit (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @ (posedge WE or negedge RE) begin
        if (WE) 
            Q <= D; // Write data to SRAM
        else if (!RE) 
            Q <= Q; // Hold the value when RE is low
    end
endmodule