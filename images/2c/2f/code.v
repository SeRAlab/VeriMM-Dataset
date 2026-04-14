module flash_memory_cell (
    input wire clk,
    input wire program,
    input wire erase,
    input wire read,
    input wire data_in,
    output reg data_out
);
    reg stored_bit;

    always @(posedge clk) begin
        if (erase) begin
            stored_bit <= 0;
        end else if (program) begin
            stored_bit <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read) begin
            data_out <= stored_bit;
        end
    end
endmodule