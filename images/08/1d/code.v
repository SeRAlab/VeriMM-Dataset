module sram_cell (
    input wire clk,
    input wire we, // write enable
    input wire d,  // data input
    output reg q   // data output
);
    always @(posedge clk) begin
        if (we) begin
            q <= d; // write data to SRAM cell
        end
        // else, retain the value of q
    end
endmodule