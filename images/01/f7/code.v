module flash_memory (
    input wire clk,
    input wire WE,
    input wire RE,
    input wire RST,
    input wire [7:0] D,
    output reg [7:0] Q
);

always @(posedge clk or posedge RST) begin
    if (RST) begin
        Q <= 8'b0; // Reset the output to 0
    end else if (WE) begin
        Q <= D; // Write the data to the output
    end else if (RE) begin
        // If RE is high and WE is low, maintain the current output
        // No action needed; Q keeps its value
    end
end

endmodule