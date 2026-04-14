module sram_4bit (
    input wire [3:0] D,
    input wire RE,
    input wire WE,
    input wire CLK,
    output reg [3:0] Q
);

always @(posedge CLK) begin
    if (WE) begin
        Q <= D; // Write operation
    end
end

always @(posedge CLK) begin
    if (RE) begin
        // Read operation is just outputting Q, no additional operation needed
    end
end

endmodule