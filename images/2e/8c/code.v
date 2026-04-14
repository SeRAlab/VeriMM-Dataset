module DRAM_Cell (
    input wire clk,
    input wire wen, // write enable
    input wire ren, // read enable
    input wire [15:0] d_in, // data input
    output reg [15:0] d_out // data output
);

    reg [15:0] storage; // 16-bit storage for the DRAM cell

    always @(posedge clk) begin
        if (wen) begin
            storage <= d_in; // Store the input value on write enable
        end
    end

    always @(posedge clk) begin
        if (ren) begin
            d_out <= storage; // Output the stored value on read enable
        end
    end
endmodule