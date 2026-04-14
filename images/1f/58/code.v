module FlashMemoryCell (
    input wire clk,
    input wire WE,
    input wire RE,
    input wire data_in,
    output reg data_out
);
    reg memory_cell;

    always @(posedge clk) begin
        if (WE) begin
            memory_cell <= data_in;
        end
        if (RE) begin
            data_out <= memory_cell;
        end
    end
endmodule