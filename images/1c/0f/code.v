module DRAM_Cell (
    input wire clk,
    input wire we,        // Write Enable
    input wire re,        // Read Enable
    input wire [15:0] din, // Data input
    output reg [15:0] dout // Data output
);

    reg [15:0] storage; // 16-bit storage

    always @(posedge clk) begin
        if (we) begin
            storage <= din; // Write data to storage
        end
    end

    always @(posedge clk) begin
        if (re) begin
            dout <= storage; // Read data from storage
        end
    end

endmodule