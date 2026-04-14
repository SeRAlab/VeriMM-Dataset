module uart_transmitter(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg tx,  
    output reg busy  
);  
    reg [3:0] bit_count;  
    reg [7:0] shift_reg;  
    reg state;  

    parameter IDLE = 1'b0;  
    parameter TRANSMIT = 1'b1;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1;  
            busy <= 0;  
            bit_count <= 0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        shift_reg <= data_in;  
                        bit_count <= 0;  
                        busy <= 1;  
                        tx <= 0; // Start bit  
                        state <= TRANSMIT;  
                    end  
                end  
                TRANSMIT: begin  
                    if (bit_count < 8) begin  
                        tx <= shift_reg[bit_count];  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        tx <= 1; // Stop bit  
                        busy <= 0;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule