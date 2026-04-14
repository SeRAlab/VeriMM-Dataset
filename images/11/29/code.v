module spi_master (
    input wire clk,
    input wire reset,
    input wire SCK_EN,
    input wire [7:0] data_in,
    output reg SCK,
    output reg CS,
    output reg MOSI
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg sending;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            SCK <= 0;
            CS <= 1;
            MOSI <= 0;
            bit_count <= 0;
            shift_reg <= 0;
            sending <= 0;
        end else begin
            if (SCK_EN) begin
                if (sending) begin
                    SCK <= ~SCK; // Toggle the clock
                    if (SCK) begin
                        MOSI <= shift_reg[7]; // Send the most significant bit
                        shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                        bit_count <= bit_count + 1;
                    end
                    if (bit_count == 7) begin
                        sending <= 0; // Finished sending data
                        CS <= 1; // Deactivate chip select
                    end
                end else begin
                    if (bit_count == 0) begin
                        CS <= 0; // Activate chip select
                        shift_reg <= data_in; // Load data into shift register
                        sending <= 1; // Start sending
                    end
                end
            end
        end
    end
endmodule