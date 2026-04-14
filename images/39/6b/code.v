module dram_cell (
    input wire clk,
    input wire [3:0] data,
    input wire control,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (control) begin
            q <= data; // Write data to cell
        end
        // No need for an else case, as q will retain its value (read)
    end
endmodule