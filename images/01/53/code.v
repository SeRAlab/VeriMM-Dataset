module sram_cell (
    input wire [3:0] data_in,
    input wire we,
    input wire ce,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge we or negedge ce) begin
        if (!ce) begin
            data_out <= 4'bz; // High impedance state when chip is disabled
        end else if (we) begin
            memory <= data_in; // Write operation
        end
    end

    always @(negedge we or posedge ce) begin
        if (ce) begin
            data_out <= memory; // Read operation
        end
    end
endmodule