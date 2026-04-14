module dram_cell (
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire READ,
    input wire WRITE,
    input wire CLK
);
    
    reg [7:0] storage;

    always @(posedge CLK) begin
        if (WRITE) begin
            storage <= data_in; // Write data to storage
        end
    end

    always @(posedge CLK) begin
        if (READ) begin
            data_out <= storage; // Output data from storage
        end
    end
endmodule