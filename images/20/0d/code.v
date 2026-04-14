module dram_cell (
    input wire clk,
    input wire reset,
    input wire write,
    input wire read,
    input wire data_in,
    output reg data_out
);
    reg stored_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stored_data <= 1'b0;
            data_out <= 1'b0;
        end else if (write) begin
            stored_data <= data_in;
        end else if (read) begin
            data_out <= stored_data;
        end
    end
endmodule