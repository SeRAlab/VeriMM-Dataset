module dram_cell (
    input wire DATA,
    input wire WRITE_ENABLE,
    input wire PRECHARGE,
    output reg Q
);
    
    always @(posedge WRITE_ENABLE or posedge PRECHARGE) begin
        if (PRECHARGE)
            Q <= 1'b0; // Reset data to 0
        else
            Q <= DATA; // Store data on WRITE_ENABLE
    end
endmodule