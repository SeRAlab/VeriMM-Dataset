module uart_transmitter(  
    input clk,  // 50 MHz clock  
    input [7:0] data_in,  
    input transmit_en,  
    output reg tx  
);  
    parameter baud_rate = 9600;  
    parameter clk_freq = 50000000;  
    parameter clk_div = clk_freq / baud_rate;  
    reg [15:0] clk_count;  
    reg [3:0] bit_index;  
    reg state; // 0: idle, 1: sending  
   
    always @(posedge clk) begin  
        if (state == 0) begin // idle state  
            tx <= 1; // idle state for UART is high  
            if (transmit_en) begin  
                state <= 1; // change state to sending  
                clk_count <= 0;  
                bit_index <= 0;  
            end  
        end else begin // sending state  
            if (clk_count < clk_div - 1) begin  
                clk_count <= clk_count + 1;  
            end else begin  
                clk_count <= 0;  
                if (bit_index == 0) begin  
                    tx <= 0; // start bit  
                end else if (bit_index < 9) begin  
                    tx <= data_in[bit_index - 1]; // data bits  
                end else begin  
                    tx <= 1; // stop bit  
                    state <= 0; // go back to idle  
                end  
                bit_index <= bit_index + 1;  
            end  
        end  
    end  
endmodule