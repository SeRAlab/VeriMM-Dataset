module dma_controller (
    input wire clk,
    input wire rst,
    input wire req1,
    input wire req2,
    output reg [7:0] data_out1,
    output reg [7:0] data_out2
);

    reg [7:0] memory [0:1]; // Simulated memory locations
    reg state; // 0 for channel 1, 1 for channel 2

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out1 <= 8'd0;
            data_out2 <= 8'd0;
            state <= 0;
        end else begin
            if (req1) begin
                data_out1 <= memory[0]; // Read from channel 1
                state <= 0;
            end else if (req2 && !req1) begin
                data_out2 <= memory[1]; // Read from channel 2 if channel 1 is not active
                state <= 1;
            end
        end
    end

    initial begin
        memory[0] = 8'd10; // Sample data for channel 1
        memory[1] = 8'd20; // Sample data for channel 2
    end
endmodule