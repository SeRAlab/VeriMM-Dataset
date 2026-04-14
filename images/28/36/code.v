module spi_controller (
    input wire clk,
    input wire start,
    input wire [7:0] data_in,
    output reg mosi,
    output reg busy
);
    reg [2:0] bit_index;
    
    always @(posedge clk) begin
        if (start) begin
            busy <= 1'b1;
            bit_index <= 3'b000;
        end else if (busy) begin
            if (bit_index < 3'b111) begin
                mosi <= data_in[7 - bit_index];
                bit_index <= bit_index + 1;
            end else begin
                busy <= 1'b0; // Transmission finished
            end
        end
    end
endmodule