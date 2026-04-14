module flash_memory (
    input wire clk,
    input wire write_enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory_cell;

    always @(posedge clk) begin
        if (write_enable)
            memory_cell <= data_in; // Write operation
        else
            data_out <= memory_cell; // Read operation
    end
endmodule