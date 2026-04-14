module sd_card_controller(  
    input clk,  
    input rst,  
    input [1:0] cmd, // 00: idle, 01: write, 10: read  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg ready  
);  

    reg [7:0] memory [0:15]; // Simple memory for SD card simulation  
    reg [3:0] address;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            address <= 0;  
            ready <= 1;  
            data_out <= 8'b0;  
        end else begin  
            case (cmd)  
                2'b01: begin // Write operation  
                    memory[address] <= data_in;  
                    ready <= 0;  
                    address <= address + 1;  
                end  
                2'b10: begin // Read operation  
                    data_out <= memory[address];  
                    ready <= 0;  
                    address <= address + 1;  
                end  
                default: begin // Idle state  
                    ready <= 1;  
                end  
            endcase  
        end  
    end  
endmodule