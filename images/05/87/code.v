module uart_receiver (  
    input wire clk,  
    input wire reset,  
    input wire rx,  
    output reg [7:0] data_out,  
    output reg data_ready  
);  
    reg [3:0] bit_count;  
    reg state;  
    reg [7:0] shift_reg;  

    parameter IDLE = 1'b0, RECEIVING = 1'b1;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            bit_count <= 0;  
            data_out <= 0;  
            data_ready <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (rx == 0) begin // Start bit detected  
                        state <= RECEIVING;  
                        bit_count <= 0;  
                        shift_reg <= 0;  
                    end  
                end  
                RECEIVING: begin  
                    if (bit_count < 8) begin  
                        shift_reg[bit_count] <= rx;  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        state <= IDLE;  
                        data_out <= shift_reg;  
                        data_ready <= 1;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule