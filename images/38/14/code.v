module serializer (
    input wire clk,
    input wire enable,
    input wire [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_counter; // 3 bits can count from 0 to 7 for 8 bits
    reg [7:0] data;

    always @(posedge clk) begin
        if (enable) begin
            if (bit_counter < 8) begin
                serial_out <= data[7 - bit_counter]; // Output the bits serially
                bit_counter <= bit_counter + 1; // Increment counter
            end else begin
                serial_out <= 0; // After all bits are sent, hold low
            end
        end else begin
            bit_counter <= 0; // Reset the counter if enable is low
            serial_out <= 0; // Hold output low
        end
    end

    always @(posedge clk) begin
        if (enable) begin
            data <= parallel_in; // Load data on enable
        end
    end
endmodule