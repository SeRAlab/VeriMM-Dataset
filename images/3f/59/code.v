module sram_cell (
    input wire [3:0] D,
    input wire WE,
    input wire RE,
    output reg [3:0] Q
);

always @(posedge WE or posedge RE) begin
    if (WE) begin
        Q <= D; // Write operation
    end
end

always @(negedge RE) begin
    if (RE) begin
        // Read operation
        // Q will output the stored data
    end
end

endmodule