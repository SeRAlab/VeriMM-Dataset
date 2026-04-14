module SRAM_4bit (
    input [3:0] data_in,
    input we,
    input clk,
    output reg [3:0] data_out
);

    reg [3:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write operation
        end
        data_out <= storage; // Read operation
    end
endmodule