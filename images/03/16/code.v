module uart_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg tx,
    output reg ready
);
    reg [3:0] bit_index;
    reg [7:0] data_buffer;
    reg sending;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1; // Idle state is high
            ready <= 1;
            bit_index <= 0;
            sending <= 0;
        end else if (start && ready) begin
            data_buffer <= data_in;
            bit_index <= 0;
            sending <= 1;
            ready <= 0;
        end else if (sending) begin
            if (bit_index < 8) begin
                tx <= data_buffer[bit_index]; // Send data bits
                bit_index <= bit_index + 1;
            end else begin
                tx <= 1; // Send stop bit
                sending <= 0;
                ready <= 1; // Ready for new data
            end
        end
    end
endmodule