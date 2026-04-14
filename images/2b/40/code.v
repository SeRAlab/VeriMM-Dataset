module SRAM_Cell (
    input wire [3:0] data_in,
    input wire we,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge we) begin
        memory <= data_in; // Write data on we signal
    end

    always @(*) begin
        if (!we) begin
            data_out = memory; // Read data when not writing
        end
    end
endmodule