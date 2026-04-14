module dram_cell (
    input wire [7:0] data_in,
    input wire RE,
    input wire WE,
    output reg [7:0] data_out
);
    reg [7:0] storage;

    always @(posedge WE) begin
        storage <= data_in;
    end

    always @(posedge RE) begin
        data_out <= storage;
    end
endmodule