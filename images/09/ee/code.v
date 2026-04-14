module spi_controller (
    input wire clk,
    input wire cs,
    input wire mosi,
    output reg miso,
    output reg [7:0] data_out,
    output reg data_ready
);
    reg [2:0] bit_count;
    
    always @(posedge clk or negedge cs) begin
        if (!cs) begin
            bit_count <= 0;
            data_out <= 0;
            data_ready <= 0;
        end else if (bit_count < 8) begin
            data_out <= {data_out[6:0], mosi};
            bit_count <= bit_count + 1;
        end else if (bit_count == 8) begin
            data_ready <= 1;
            miso <= data_out[7]; // Send the MSB out
        end
    end

    always @(posedge clk) begin
        if (data_ready) begin
            miso <= data_out[7]; // Continue sending data if ready
            data_out <= {data_out[6:0], 1'b0}; // Shift out the next bit
            if (bit_count > 0) begin
                bit_count <= bit_count - 1;
            end else begin
                data_ready <= 0; // Reset when done
            end
        end
    end
endmodule