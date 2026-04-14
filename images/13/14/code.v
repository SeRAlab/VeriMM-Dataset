module uart_receiver(  
    input wire clk,  
    input wire rst,  
    input wire Rx,  
    output reg [7:0] data_out,  
    output reg output_ready  
);  
    reg [3:0] bit_count;  
    reg [7:0] shift_reg;  
    reg state; // 0: idle, 1: receiving  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            bit_count <= 4'b0;  
            shift_reg <= 8'b0;  
            output_ready <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: begin // Idle state  
                    if (Rx == 0) begin // Detect start bit  
                        state <= 1;  
                        bit_count <= 0;  
                    end  
                end  
                1: begin // Receiving state  
                    if (bit_count < 8) begin  
                        shift_reg[bit_count] <= Rx;  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        output_ready <= 1;  
                        data_out <= shift_reg;  
                        state <= 0; // Go back to idle state  
                    end  
                end  
            endcase  
        end  
    end  
endmodule