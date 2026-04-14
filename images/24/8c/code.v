module uart_transmitter (  
    input clk,  
    input reset,  
    input start,  
    input [7:0] data,  
    input baud_rate,  
    output reg tx,  
    output reg busy  
);  
    reg [3:0] bit_index;  
    reg [10:0] shift_reg;  
    reg state;  

    localparam IDLE = 1'b0;  
    localparam TRANSMIT = 1'b1;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1;  
            busy <= 0;  
            bit_index <= 0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        shift_reg <= {1'b1, data, 1'b0}; // stop bit, data, start bit  
                        bit_index <= 0;  
                        busy <= 1;  
                        state <= TRANSMIT;  
                    end  
                end  
                TRANSMIT: begin  
                    if (bit_index < 11) begin  
                        tx <= shift_reg[bit_index];  
                        bit_index <= bit_index + 1;  
                    end else begin  
                        busy <= 0;  
                        tx <= 1;  // idle state after transmission  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule