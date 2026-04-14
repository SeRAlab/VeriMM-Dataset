module dram_cell (
    input wire [15:0] idata,
    input wire we,
    input wire re,
    input wire clk,
    output reg [15:0] odata
);
    reg [15:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= idata; // Write data to storage
        end
    end

    always @(posedge clk) begin
        if (re) begin
            odata <= storage; // Read data from storage
        end
    end
endmodule