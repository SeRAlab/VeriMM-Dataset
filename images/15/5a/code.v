module uart_tx(  
    input wire clk,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg tx,  
    output reg ready  
);  
    reg [3:0] state;  
    reg [3:0] bit_index;  
    reg [7:0] data;  

    parameter IDLE = 4'b0000;  
    parameter START_BIT = 4'b0001;  
    parameter DATA_BITS = 4'b0010;  
    parameter STOP_BIT = 4'b0011;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                if (start) begin  
                    data <= data_in;  
                    tx <= 1'b0;  // Start bit  
                    bit_index <= 0;  
                    state <= START_BIT;  
                    ready <= 0;  
                end  
            end  
            START_BIT: begin  
                state <= DATA_BITS;  
            end  
            DATA_BITS: begin  
                if (bit_index < 8) begin  
                    tx <= data[bit_index];  
                    bit_index <= bit_index + 1;  
                end else begin  
                    state <= STOP_BIT;  
                end  
            end  
            STOP_BIT: begin  
                tx <= 1'b1;  // Stop bit  
                ready <= 1;  
                state <= IDLE;  
            end  
        endcase  
    end  
endmodule