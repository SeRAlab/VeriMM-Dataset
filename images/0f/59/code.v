module i2c_controller(  
    input wire clk,  
    input wire start,  
    input wire stop,  
    input wire [7:0] data_in,  
    output reg sda,  
    output reg scl  
);  

    reg [3:0] state;  
    parameter IDLE = 4'b0000, START = 4'b0001, SEND = 4'b0010, ACK = 4'b0011, STOP = 4'b0100;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                sda <= 1;  
                scl <= 1;  
                if (start)  
                    state <= START;  
            end  
            START: begin  
                sda <= 0;  
                state <= SEND;  
            end  
            SEND: begin  
                sda <= data_in[7];  
                state <= ACK;  
            end  
            ACK: begin  
                sda <= 1;  
                state <= STOP;  
            end  
            STOP: begin  
                sda <= 1;  
                state <= IDLE;  
            end  
            default: state <= IDLE;  
        endcase  
        scl <= ~scl;  
    end  
endmodule