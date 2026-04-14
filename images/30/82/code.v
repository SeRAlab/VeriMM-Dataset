module SRAM_Cell (
    input wire we,     // Write enable
    input wire re,     // Read enable
    input wire reset,  // Reset signal
    input wire [3:0] data_in, // 4-bit data input
    output reg [3:0] data_out   // 4-bit data output
);
    
    always @(posedge reset or posedge we) begin
        if (reset)
            data_out <= 4'b0000; // Initialize to zero
        else if (we)
            data_out <= data_in; // Write data
    end

    always @(posedge re) begin
        if (re)
            data_out <= data_out; // Read data (no change)
    end
endmodule