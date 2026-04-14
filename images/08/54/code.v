module sram_16bit(
    input wire [15:0] data,
    input wire we,
    input wire re,
    input wire reset,
    output reg [15:0] q
);
    always @(posedge reset) begin
        q <= 16'b0; // Reset the stored value to 0
    end

    always @(posedge we) begin
        q <= data; // Write data on write enable
    end

    always @(posedge re) begin
        // Read operation: output the stored value
        // The output is already reflected in the 'q' register
    end
endmodule