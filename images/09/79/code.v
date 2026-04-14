module DRAM_Cell (
    input wire [3:0] data_in,
    input wire WE,
    input wire RE,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge WE) begin
        storage <= data_in; // Write data to storage when WE is high
    end

    always @(posedge RE) begin
        data_out <= storage; // Output data when RE is high
    end
endmodule