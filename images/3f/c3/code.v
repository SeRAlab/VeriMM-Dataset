module flash_memory_cell (
    input wire clk,
    input wire reset,
    input wire read_enable,
    input wire program_enable,
    input wire erase_enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg ready
);
    reg [7:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 8'b0;
            ready <= 1'b1;
        end else begin
            if (erase_enable) begin
                memory <= 8'b0; // Erase memory
                ready <= 1'b1;
            end else if (program_enable) begin
                memory <= data_in; // Program memory
                ready <= 1'b1;
            end else if (read_enable) begin
                data_out <= memory; // Read memory
                ready <= 1'b1;
            end else begin
                ready <= 1'b0; // Not ready if none of the operations are triggered
            end
        end
    end
endmodule