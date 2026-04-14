module uart_receiver (  
    input wire clk,  
    input wire reset,  
    input wire rx,  
    output reg [7:0] data_out,  
    output reg data_ready  
);  
    parameter IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b011;  
    reg [2:0] state, next_state;  
    reg [2:0] bit_counter;  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            data_ready <= 0;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(state or rx or bit_counter) begin  
        case (state)  
            IDLE: begin  
                data_ready = 0;  
                if (rx == 0) begin  // Start bit detected  
                    next_state = START;  
                    bit_counter = 0;  
                end else begin  
                    next_state = IDLE;  
                end  
            end  
            START: begin  
                next_state = DATA;  
                shift_reg = 0;  
            end  
            DATA: begin  
                if (bit_counter < 8) begin  
                    shift_reg[bit_counter] = rx;  
                    bit_counter = bit_counter + 1;  
                end else begin  
                    next_state = STOP;  
                end  
            end  
            STOP: begin  
                data_out = shift_reg;  
                data_ready = 1;  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule