module sd_card_controller (  
    input clk,  
    input reset,  
    input [1:0] command, // 00: idle, 01: read, 10: write  
    input [7:0] data_in,  
    output reg busy,  
    output reg done,  
    output reg [7:0] data_out  
);  

    reg [7:0] memory [0:255]; // Simple memory to simulate SD card storage  
    reg [7:0] address;  
    reg state; // 0: idle, 1: busy  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            busy <= 0;  
            done <= 0;  
            state <= 0;  
            address <= 0;  
            data_out <= 0;  
        end else begin  
            case (command)  
                2'b00: begin  
                    busy <= 0;  
                    done <= 0;  
                end  
                2'b01: begin // Read command  
                    busy <= 1;  
                    state <= 1;  
                    data_out <= memory[address];  
                    done <= 1;  
                end  
                2'b10: begin // Write command  
                    busy <= 1;  
                    state <= 1;  
                    memory[address] <= data_in;  
                    done <= 1;  
                end  
                default: begin  
                    busy <= 0;  
                    done <= 0;  
                end  
            endcase  
        end  
    end  
endmodule