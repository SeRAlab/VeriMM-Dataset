module uart_transmitter #(parameter BAUD_RATE = 9600) (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    input wire send,  
    output reg tx  
);  
    reg [3:0] state;  
    reg [7:0] shift_reg;  
    reg [3:0] bit_count;  

    localparam IDLE = 4'b0000,  
               START_BIT = 4'b0001,  
               DATA_BITS = 4'b0010,  
               STOP_BIT = 4'b0011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            tx <= 1;  
            bit_count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (send) begin  
                        shift_reg <= data_in;  
                        tx <= 0;  // Start bit  
                        state <= START_BIT;  
                    end  
                end  
                START_BIT: begin  
                    state <= DATA_BITS;  
                    bit_count <= 0;  
                end  
                DATA_BITS: begin  
                    if (bit_count < 8) begin  
                        tx <= shift_reg[bit_count];  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        state <= STOP_BIT;  
                    end  
                end  
                STOP_BIT: begin  
                    tx <= 1;  // Stop bit  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule