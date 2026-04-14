module top_module(
    /*
     * Clock: 125MHz
     * Reset: Synchronous
     */
    input  wire       clk_125mhz,
    input  wire       rst_125mhz,
    /*
     * GPIO
     */
    input  wire       btnu,
    input  wire       btnl,
    input  wire       btnd,
    input  wire       btnr,
    input  wire       btnc,
    input  wire [7:0] sw,
    output wire       ledu,
    output wire       ledl,
    output wire       ledd,
    output wire       ledr,
    output wire       ledc,
    output wire [7:0] led,
    /*
     * UART: 115200 bps, 8N1
     */
    output wire       uart_rxd,
    input  wire       uart_txd,
    input  wire       uart_rts,
    output wire       uart_cts
);// LED control
reg [4:0] led_state;

always @ (posedge clk_125mhz) begin
    if (rst_125mhz) begin
        led_state <= 5'b00000;
    end else begin
        led_state <= {btnc, btnr, btnd, btnl, btnu};
    end
end

assign ledu = led_state[0];
assign ledl = led_state[1];
assign ledd = led_state[2];
assign ledr = led_state[3];
assign ledc = led_state[4];
assign led = 8'h00;

// UART control
reg [7:0] uart_data;

always @ (posedge clk_125mhz) begin
    if (rst_125mhz) begin
        uart_data <= 8'h00;
    end else if (uart_rxd) begin
        uart_data <= uart_txd;
    end
end

assign uart_rxd = uart_data[0];
assign uart_cts = uart_data[1];

endmodule