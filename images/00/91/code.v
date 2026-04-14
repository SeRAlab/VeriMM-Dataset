module uart_transmitter(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    input wire send,  
    output reg tx  
);  
    reg [3:0] bit_count;  
    reg [10:0] shift_reg;  
    reg transmitting;  
    parameter IDLE = 1'b0, TRANSMITTING = 1'b1;  
    reg state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1;  
            bit_count <= 0;  
            shift_reg <= 0;  
            state <= IDLE;  
            transmitting <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (send) begin  
                        shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit, data, start bit  
                        bit_count <= 0;  
                        state <= TRANSMITTING;  
                        transmitting <= 1;  
                    end  
                end  
                TRANSMITTING: begin  
                    if (bit_count < 11) begin  
                        tx <= shift_reg[bit_count];  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        state <= IDLE;  
                        transmitting <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule