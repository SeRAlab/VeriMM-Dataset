module dram_cell(
    input [7:0] data_in,
    input we,
    input clk,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in;  // Store the data_in when we is high
        end
    end

    always @(*) begin
        data_out = memory;  // Output the stored value
    end
endmodule