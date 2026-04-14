module spi_controller (
    input wire clk,
    input wire reset,
    input wire mosi,
    output reg miso,
    input wire cs,
    output reg sclk,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg ready
);

    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            sclk <= 0;
            data_out <= 0;
            ready <= 1;
            miso <= 0;
        end else if (!cs) begin
            if (bit_count < 8) begin
                sclk <= ~sclk; // toggle clock
                if (sclk) begin
                    miso <= data_in[7 - bit_count]; // send data
                    shift_reg[bit_count] <= mosi; // receive data
                    bit_count <= bit_count + 1;
                end
            end else begin
                data_out <= shift_reg; // update output when done
                ready <= 1; // signal ready after transmission
                bit_count <= 0; // reset bit count
            end
        end
    end
endmodule