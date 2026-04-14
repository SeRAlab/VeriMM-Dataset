module top_module(
    input wire CLK_100MHz,
    input wire reset,
    input wire Rx,
    output wire Tx,
    output reg transmit, // Changed to reg
    output reg [7:0] LED, // Changed to reg
    output reg [7:0] recv_error // Changed to reg
);reg [7:0] display_byte;
reg [7:0] tx_byte;
reg is_received;
reg is_transmitting;
reg [7:0] rx_byte; // Added declaration for rx_byte

assign Tx = tx_byte[0];
assign is_receiving = !Rx;
assign is_transmitting = (tx_byte != 8'b00000000);

always @(posedge CLK_100MHz) begin
    if (reset) begin
        display_byte <= 8'b00000000;
        tx_byte <= 8'b00000000;
        transmit <= 1'b0;
        is_received <= 1'b0;
        recv_error <= 8'b00000000;
    end else begin
        if (is_received) begin
            display_byte <= rx_byte;
            tx_byte <= rx_byte;
            LED <= rx_byte;
            transmit <= 1'b1;
            is_received <= 1'b0;
        end else if (is_transmitting) begin
            tx_byte <= {tx_byte[6:0], 1'b0};
            transmit <= 1'b1;
        end else begin
            tx_byte <= 8'b00000000;
            transmit <= 1'b0;
        end
    end
end

always @(posedge CLK_100MHz) begin
    if (reset) begin
        recv_error <= 8'b00000000;
    end else begin
        if (is_received) begin
            recv_error <= 8'b00000000;
        end else if (Rx == 1'b0) begin
            recv_error <= 8'b00000001;
        end
    end
end

always @(posedge CLK_100MHz) begin
    if (reset) begin
        is_received <= 1'b0;
    end else begin
        if (Rx == 1'b0) begin
            is_received <= 1'b1;
        end
    end
end

endmodule