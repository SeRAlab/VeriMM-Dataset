module uart_transmitter(  
    input clk,  
    input tx_en,  
    input [7:0] data_in,  
    output reg tx  
);  
    reg [3:0] state;  
    reg [3:0] bit_count;  
    reg [7:0] data_reg;  
    parameter IDLE = 4'b0000;  
    parameter START = 4'b0001;  
    parameter DATA = 4'b0010;  
    parameter STOP = 4'b0011;  
    
    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                tx <= 1;  
                if (tx_en) begin  
                    state <= START;  
                    data_reg <= data_in;  
                    bit_count <= 0;  
                end  
            end  
            START: begin  
                tx <= 0; // Start bit  
                state <= DATA;  
            end  
            DATA: begin  
                tx <= data_reg[bit_count];  
                if (bit_count < 7)  
                    bit_count <= bit_count + 1;  
                else  
                    state <= STOP;  
            end  
            STOP: begin  
                tx <= 1; // Stop bit  
                state <= IDLE;  
            end  
        endcase  
    end  
endmodule