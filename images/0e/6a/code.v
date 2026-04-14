module I2C_Controller (  
    input wire start,  
    input wire stop,  
    input wire clock,  
    input wire [7:0] data_in,  
    output reg data_out  
);  
    reg [3:0] state;  
    parameter IDLE = 4'b0000, START = 4'b0001, SEND = 4'b0010, STOP = 4'b0011;  

    always @(posedge clock) begin  
        case (state)  
            IDLE: begin  
                data_out <= 1'b1;  
                if (start) state <= START;  
            end  
            START: begin  
                data_out <= 1'b0; // Start condition  
                state <= SEND;  
            end  
            SEND: begin  
                data_out <= data_in; // Send data  
                state <= STOP;  
            end  
            STOP: begin  
                data_out <= 1'b1; // Stop condition  
                state <= IDLE;  
            end  
            default: state <= IDLE;  
        endcase  
    end  
endmodule