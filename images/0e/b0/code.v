module uart_transmitter (  
    input wire clk,  
    input wire tx_en,  
    input wire [7:0] data_in,  
    input wire start_bit,  
    input wire stop_bit,  
    output reg tx  
);  
    reg [3:0] state;  
    reg [3:0] bit_count;  
    reg [10:0] shift_reg;  
    parameter IDLE = 4'b0000, START = 4'b0001, DATA = 4'b0010, STOP = 4'b0011;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                tx <= 1;  
                if (tx_en) begin  
                    shift_reg <= {stop_bit, data_in, start_bit};  
                    bit_count <= 0;  
                    state <= START;  
                end  
            end  
            START: begin  
                tx <= shift_reg[10];  
                bit_count <= bit_count + 1;  
                if (bit_count == 0)  
                    state <= DATA;  
            end  
            DATA: begin  
                tx <= shift_reg[10 - bit_count];  
                bit_count <= bit_count + 1;  
                if (bit_count == 8)  
                    state <= STOP;  
            end  
            STOP: begin  
                tx <= stop_bit;  
                if (bit_count == 9)  
                    state <= IDLE;  
            end  
        endcase  
    end  
endmodule