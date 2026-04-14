module sample_rate_converter(
    input wire clk,             // Input clock
    input wire rst_n,           // Active low reset
    input wire [3:0] data_in,   // 4-bit input data
    output reg [3:0] data_out   // 4-bit output data
);
    reg [1:0] counter;          // Counter to track clock cycles
    reg [3:0] buffer;           // Buffer to hold input data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 2'b00;
            data_out <= 4'b0000;
            buffer <= 4'b0000;
        end else begin
            buffer <= data_in;    // Store input data in buffer
            counter <= counter + 1;

            if (counter == 2'b11) begin
                data_out <= buffer; // Output data every 4th clock cycle
                counter <= 2'b00;    // Reset counter
            end
        end
    end
endmodule