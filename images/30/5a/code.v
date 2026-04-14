module dram_cell (
    input wire we,           // Write enable
    input wire re,           // Read enable
    input wire [3:0] data_in, // 4-bit data input
    output reg [3:0] data_out // 4-bit data output
);
    reg [3:0] storage; // Internal storage for the DRAM cell

    always @(*) begin
        if (we) begin
            storage = data_in; // Write to storage
        end
    end

    always @(posedge re) begin
        if (re) begin
            data_out = storage; // Read from storage
        end
    end
endmodule