module uart_receiver(  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [7:0] data_out,  
    output reg data_ready  
);  
    reg [3:0] bit_count;  
    reg [7:0] shift_reg;  
    reg state; // 0: idle, 1: receiving  

    // State machine for receiving data  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 0;  
            shift_reg <= 0;  
            data_out <= 0;  
            data_ready <= 0;  
            state <= 0;  
        end else begin  
            case (state)  
                0: begin  // Idle state  
                    if (serial_in == 0) begin // Start bit detected  
                        state <= 1;  
                        bit_count <= 0;  
                    end  
                end  
                1: begin  // Receiving state  
                    if (bit_count < 10) begin  
                        if (bit_count < 9) begin  
                            shift_reg <= {serial_in, shift_reg[7:1]}; // Shift in data  
                        end  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        data_out <= shift_reg; // Load data  
                        data_ready <= 1; // Indicate data is ready  
                        state <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule