module dram_cell (
    input wire [3:0] data_in,
    input wire WE, // Write Enable
    input wire RE, // Read Enable
    input wire CLK,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge CLK) begin
        if (WE) begin
            storage <= data_in; // Write data to storage
        end
        if (RE) begin
            data_out <= storage; // Read data from storage
        end
    end
endmodule