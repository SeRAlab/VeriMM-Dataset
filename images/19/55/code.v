module uart_controller (
    input clk,
    input reset,
    input send,
    input [7:0] data_in,
    output reg tx,
    output reg [7:0] data_out,
    output reg received
);
    reg [3:0] bit_counter;
    reg [7:0] buffer;
    reg sending;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1; // idle state
            bit_counter <= 0;
            sending <= 0;
            received <= 0;
        end else begin
            if (send && !sending) begin
                sending <= 1;
                tx <= 0; // start bit
                bit_counter <= 0;
                buffer <= data_in;
            end else if (sending) begin
                if (bit_counter < 8) begin
                    tx <= buffer[bit_counter]; // send data bits
                    bit_counter <= bit_counter + 1;
                end else if (bit_counter == 8) begin
                    tx <= 1; // stop bit
                    received <= 1;
                    sending <= 0;
                    data_out <= buffer; // store received data
                end else begin
                    sending <= 0; // reset sending
                end
            end
        end
    end
endmodule