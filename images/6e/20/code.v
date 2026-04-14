module top_module(
    input wire clk,
    input wire reset,
    input wire new_input,
    output wire output_sum
);reg [15:0] memory_block [0:7];
reg [15:0] sum;

integer i;

always @(posedge clk) begin
    if (reset) begin
        // Reset the memory block and the sum
        for (i = 0; i < 8; i = i + 1) begin
            memory_block[i] <= 0;
        end
        sum <= 0;
    end else begin
        // Shift the memory block and add the new input
        for (i = 7; i > 0; i = i - 1) begin
            memory_block[i] <= memory_block[i - 1];
        end
        memory_block[0] <= new_input;

        // Update the sum
        sum <= 0;
        for (i = 0; i < 8; i = i + 1) begin
            sum <= sum + memory_block[i];
        end
    end
end

assign output_sum = sum;

endmodule