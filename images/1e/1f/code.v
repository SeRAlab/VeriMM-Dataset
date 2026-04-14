module dma_controller(  
    input clk,  
    input reset,  
    input [3:0] req,      // Request from 4 channels  
    output reg [3:0] ack, // Acknowledge the channel  
    output reg [7:0] data // Data register  
);  
    reg [1:0] state;      // Controller state  
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            ack <= 4'b0000;  
            data <= 8'b00000000;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (req != 4'b0000) begin  
                        ack <= req;  
                        state <= (req[0]) ? READ : WRITE;  
                    end  
                end  
                READ: begin  
                    data <= 8'hFF; // Simulating read data  
                    state <= IDLE;  
                end  
                WRITE: begin  
                    data <= 8'hAA; // Simulated write data  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule