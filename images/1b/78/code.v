module sata_controller (  
    input wire clk,  
    input wire rst,  
    input wire [1:0] command, // 00: Idle, 01: Read, 10: Write  
    output reg ready,  
    output reg [1:0] state  
);  

    parameter IDLE = 2'b00;  
    parameter READ = 2'b01;  
    parameter WRITE = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            ready <= 1;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (command == 2'b01) begin  
                        state <= READ;  
                        ready <= 0;  
                    end else if (command == 2'b10) begin  
                        state <= WRITE;  
                        ready <= 0;  
                    end  
                end  
                READ: begin  
                    state <= IDLE;  
                    ready <= 1;  
                end  
                WRITE: begin  
                    state <= IDLE;  
                    ready <= 1;  
                end  
            endcase  
        end  
    end  
endmodule