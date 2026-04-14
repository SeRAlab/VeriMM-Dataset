module dram_cell (
    input wire [7:0] data,
    input wire we,    // Write enable
    input wire re,    // Read enable
    input wire reset,  // Reset signal
    output reg [7:0] q  // Output data
);
  
always @(posedge reset or posedge we) begin
    if (reset) begin
        q <= 8'b0; // Reset the stored value to 0
    end else if (we) begin
        q <= data; // Write the input data to the output
    end
end

always @(posedge re) begin
    // Output is already updated during write or reset
end

endmodule