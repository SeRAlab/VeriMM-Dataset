module spi_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    input wire cpol,
    input wire cpha,
    output reg mosi,
    output reg sclk,
    output reg cs,
    output reg [7:0] data_out,
    output reg done
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg sending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mosi <= 1'b0;
            sclk <= 1'b0;
            cs <= 1'b1; // Active low
            done <= 1'b0;
            bit_count <= 3'b0;
            sending <= 1'b0;
        end else begin
            if (start && !sending) begin
                shift_reg <= data_in;
                cs <= 1'b0; // Start transmission
                sending <= 1'b1;
                bit_count <= 3'b0;
                done <= 1'b0;
            end else if (sending) begin
                if (bit_count < 3'd8) begin
                    if (cpha) begin
                        sclk <= ~sclk; // Toggle clock
                        if (sclk) begin
                            mosi <= shift_reg[7 - bit_count]; // Send bit
                            bit_count <= bit_count + 1'b1;
                        end
                    end else begin
                        if (bit_count == 3'd0) begin
                            sclk <= 1'b1; // Start clock high
                        end else if (bit_count < 3'd8) begin
                            sclk <= ~sclk; // Toggle clock
                            if (sclk) begin
                                mosi <= shift_reg[7 - bit_count]; // Send bit
                                bit_count <= bit_count + 1'b1;
                            end
                        end
                    end
                end else begin
                    done <= 1'b1; // Transmission complete
                    cs <= 1'b1; // End transmission
                    sending <= 1'b0;
                end
            end
        end
    end
    
endmodule