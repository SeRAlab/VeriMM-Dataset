module uart_tx (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire send,
    output reg tx,
    output reg busy
);
    reg [3:0] bit_index;
    reg [9:0] shift_reg;
    reg [15:0] clk_div;
    reg sending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1; // Idle state is high
            busy <= 0;
            bit_index <= 0;
            sending <= 0;
            clk_div <= 0;
        end else begin
            if (sending) begin
                clk_div <= clk_div + 1;
                if (clk_div == 16'd104) begin // Simulate baud rate (assuming 9600 baud with 50 MHz clock)
                    clk_div <= 0;
                    tx <= shift_reg[bit_index];
                    bit_index <= bit_index + 1;

                    if (bit_index == 10) begin
                        busy <= 0;
                        sending <= 0;
                        bit_index <= 0;
                        tx <= 1; // End with idle state
                    end
                end
            end else if (send) begin
                shift_reg <= {1'b1, data_in, 1'b0}; // Start bit + data + stop bit
                busy <= 1;
                sending <= 1;
                bit_index <= 0;
                tx <= 0; // Start bit
            end
        end
    end
endmodule