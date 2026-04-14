module SRAM_cell (
    input wire clk,
    input wire we,       // write enable
    input wire re,       // read enable
    input wire d,        // data input
    output reg q         // data output
);
    reg stored_value;    // internal storage

    always @(posedge clk) begin
        if (we) begin
            stored_value <= d; // write data to storage
        end
    end

    always @(posedge clk) begin
        if (re) begin
            q <= stored_value; // output stored value on read enable
        end
    end
endmodule