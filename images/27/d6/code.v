module dma_controller (
    input clk,
    input rst,
    input start_ch1,
    input start_ch2,
    output reg busy_ch1,
    output reg busy_ch2,
    output reg [7:0] data_reg_ch1,
    output reg [7:0] data_reg_ch2
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy_ch1 <= 0;
            busy_ch2 <= 0;
            data_reg_ch1 <= 8'b0;
            data_reg_ch2 <= 8'b0;
        end else begin
            if (start_ch1 && !busy_ch1) begin
                busy_ch1 <= 1;
                data_reg_ch1 <= 8'hAA; // Example data for channel 1
            end
            if (start_ch2 && !busy_ch2) begin
                busy_ch2 <= 1;
                data_reg_ch2 <= 8'hBB; // Example data for channel 2
            end
            // Simulate transfer completion
            if (busy_ch1) busy_ch1 <= 0; // Transfer complete for channel 1
            if (busy_ch2) busy_ch2 <= 0; // Transfer complete for channel 2
        end
    end
endmodule