module dram_cell (
    input wire [3:0] D,
    input wire WE,
    input wire RE,
    output reg [3:0] Q
);
    reg [3:0] storage; // internal storage for the DRAM cell

    always @(posedge WE or posedge RE) begin
        if (WE) begin
            storage <= D; // store data on write enable
        end
    end

    always @(posedge RE) begin
        if (RE) begin
            Q <= storage; // output stored data on read enable
        end
    end
endmodule