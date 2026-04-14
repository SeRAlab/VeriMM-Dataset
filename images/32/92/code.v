module dram_cell (
    input wire d,
    input wire we,
    input wire clk,
    output reg q
);
    reg stored_bit;

    always @(posedge clk) begin
        if (we) begin
            stored_bit <= d;
        end
    end

    always @* begin
        q = stored_bit;
    end
endmodule