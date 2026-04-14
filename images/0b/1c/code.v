module dram_cell (
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    input wire we, // write enable
    input wire clk
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write operation
        end
        data_out <= storage; // Read operation
    end
endmodule