module dram_cell (
    input wire addr,
    input wire data_in,
    input wire we,
    input wire clk,
    output reg data_out
);
    reg stored_bit;

    always @(posedge clk) begin
        if (we) begin
            stored_bit <= data_in; // Write operation
        end
    end

    always @(negedge clk) begin
        if (!we) begin
            data_out <= stored_bit; // Read operation
        end
    end
endmodule