module sram_cell (
    input wire [15:0] data_in,
    input wire WE,    // Write Enable
    input wire RE,    // Read Enable
    output reg [15:0] data_out
);
    reg [15:0] memory; // 16-bit memory cell

    always @(*) begin
        if (WE && !RE) begin
            memory <= data_in; // Write operation
        end else if (RE && !WE) begin
            data_out <= memory; // Read operation
        end
    end
endmodule