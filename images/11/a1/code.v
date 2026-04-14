module uart_tx (  
    input clk,  
    input rst,  
    input tx_en,  
    input [7:0] data_in,  
    output reg tx,  
    output reg busy  
);  
    reg [3:0] bit_cnt;  
    reg [7:0] shift_reg;  
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;  
    reg [1:0] state, next_state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            busy <= 0;  
            tx <= 1;  
            bit_cnt <= 0;  
        end else begin  
            state <= next_state;  
            if (state == START) begin  
                busy <= 1;  
            end else if (state == STOP) begin  
                busy <= 0;  
            end  
        end  
    end  

    always @(*) begin  
        next_state = state;  
        case (state)  
            IDLE: begin  
                if (tx_en) begin  
                    next_state = START;  
                    shift_reg = data_in;  
                    bit_cnt = 0;  
                end  
            end  
            START: begin  
                tx = 0; // Start bit  
                if (bit_cnt == 8)  
                    next_state = STOP;  
                else  
                    next_state = DATA;  
            end  
            DATA: begin  
                tx = shift_reg[bit_cnt];  
                if (bit_cnt < 7)  
                    bit_cnt = bit_cnt + 1;  
                else  
                    next_state = STOP;  
            end  
            STOP: begin  
                tx = 1; // Stop bit  
                next_state = IDLE;  
            end  
        endcase  
    end  
endmodule