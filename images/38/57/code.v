module dram_cell (
    input wire write_enable,
    input wire [3:0] data_in,
    input wire [1:0] row_select,
    output reg [3:0] data_out
);

    reg [3:0] memory [3:0]; // 4 rows of 4 bits each

    always @(posedge write_enable) begin
        memory[row_select] <= data_in; // Write operation
    end

    always @(*) begin
        data_out = memory[row_select]; // Read operation
    end

endmodule