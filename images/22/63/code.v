module sram_cell (
    input wire [7:0] data_in,
    input wire we,
    input wire clk,
    output reg [7:0] data_out
);
    reg [7:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write data to SRAM
        end
        data_out <= storage; // Output stored data
    end
endmodule