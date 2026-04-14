module dram_cell (
    input wire [3:0] data,
    input wire we,
    input wire re,
    input wire reset,
    output reg [3:0] q
);
    always @(posedge reset or posedge we) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (we) begin
            q <= data;
        end
    end
    
    always @(posedge re) begin
        if (re) begin
            // Output the stored data
            // No need to assign since q is always updated when we is high
        end
    end
endmodule