module pcie_tx_controller(
    input clk,
    input reset,
    input start_read,
    input start_write,
    input [31:0] data_in,
    output reg [31:0] data_out,
    output reg transaction_status // 0: idle, 1: read, 2: write
);

    reg [31:0] memory [0:255]; // Simple memory for transactions
    reg [7:0] address;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transaction_status <= 0;
            data_out <= 32'b0;
            address <= 8'b0;
        end
        else begin
            if (start_read) begin
                transaction_status <= 1; // Read transaction in progress
                data_out <= memory[address]; // Read from memory
            end
            else if (start_write) begin
                transaction_status <= 2; // Write transaction in progress
                memory[address] <= data_in; // Write to memory
            end
            else begin
                transaction_status <= 0; // Idle
            end
        end
    end
endmodule