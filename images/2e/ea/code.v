module dram_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    initial begin
        Q = 0; // initial state
    end
    
    always @(posedge WE) begin
        Q <= D; // write data to cell
    end
    
    always @(posedge RE) begin
        // read operation, output Q
    end
endmodule