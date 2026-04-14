module dram_cell (
    input wire [3:0] data_in,
    input wire control,
    input wire clk,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (control) begin
            storage <= data_in; // Write operation
        end else begin
            data_out <= storage; // Read operation
        end
    end
endmodule