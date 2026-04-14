module uart_clock(
    input clock,
    output uart_tick,
    output uart_tick_16x
    );
    reg [14:0] accumulator = 15'h0000;
    always @(posedge clock) begin
        accumulator <= accumulator[13:0] + 453;
    end
    assign uart_tick_16x = accumulator[14];
    reg [3:0] uart_16x_count = 4'h0;
    always @(posedge clock) begin
        uart_16x_count <= (uart_tick_16x) ? uart_16x_count + 1 : uart_16x_count;
    end
    assign uart_tick = (uart_tick_16x==1'b1 && (uart_16x_count == 4'b1111));
endmodule