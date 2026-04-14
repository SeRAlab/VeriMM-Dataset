module sram_cell (
    input wire clk,
    input wire we,        // Write enable
    input wire [7:0] data_in,   // 8-bit input data
    output reg [7:0] data_out   // 8-bit output data
);
    reg [7:0] memory; // internal memory storage

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write operation
        end
    end

    always @(*) begin
        data_out = memory; // Output current stored value
    end
endmodule