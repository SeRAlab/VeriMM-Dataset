module top_module(
    input CLK,
    input RX,
    output reg TX,
    output reg LED1,
    output reg LED2,
    output reg LED3,
    output reg LED4,
    output reg LED5
);reg [1:0] state = 0;

    always @(posedge CLK) begin
        case(state)
            2'b00: begin
                if(RX == 1) begin
                    state <= 2'b01;
                    LED1 <= 1;
                    LED2 <= 1;
                    LED3 <= 1;
                    LED4 <= 1;
                    LED5 <= 1;
                end else if(RX == 2) begin
                    state <= 2'b10;
                    LED1 <= 0;
                    LED2 <= 0;
                    LED3 <= 0;
                    LED4 <= 0;
                    LED5 <= 0;
                end else if(RX == 3) begin
                    state <= 2'b11;
                    LED1 <= 1;
                    LED2 <= 1;
                    LED3 <= 0;
                    LED4 <= 0;
                    LED5 <= 0;
                end else if(RX == 4) begin
                    state <= 2'b11;
                    LED1 <= 0;
                    LED2 <= 0;
                    LED3 <= 1;
                    LED4 <= 1;
                    LED5 <= 0;
                end else if(RX == 5) begin
                    state <= 2'b11;
                    LED1 <= 0;
                    LED2 <= 0;
                    LED3 <= 0;
                    LED4 <= 0;
                    LED5 <= 1;
                end
            end
            2'b01, 2'b10: begin
                TX <= RX;
                state <= 2'b00;
            end
            2'b11: begin
                if(RX == 1 || RX == 2 || RX == 5) begin
                    state <= 2'b00;
                end
            end
        endcase
    end

endmodule