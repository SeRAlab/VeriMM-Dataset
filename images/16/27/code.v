module SRAM_Cell (
    input wire [3:0] data,
    input wire we,
    input wire re,
    output reg [3:0] q
);
    always @(posedge we or posedge re) begin
        if (we) begin
            q <= data; // Write data to SRAM
        end
    end

    always @(posedge re) begin
        if (re) begin
            // Output the stored data
            // This block will be triggered on read enable
        end
    end
endmodule