module sd_card_controller (
    input wire clk,
    input wire reset,
    input wire cmd, // 0 for read, 1 for write
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory; // Simple memory to hold written data

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 8'b0; // Reset memory
            data_out <= 8'b0; // Reset output
        end else begin
            if (cmd) begin
                memory <= data_in; // Write data
                data_out <= 8'b0; // Clear output on write
            end else begin
                data_out <= memory; // Read data
            end
        end
    end
endmodule