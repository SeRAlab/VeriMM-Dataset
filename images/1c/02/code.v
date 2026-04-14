module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter DATA_WIDTH = 8) (  
    input clk,  
    input reset,  
    input send_enable,  
    input ack_received,  
    input [DATA_WIDTH-1:0] data_in,  
    output reg [DATA_WIDTH-1:0] data_out,  
    output reg [WINDOW_SIZE-1:0] window_status,  
    output reg busy  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, SENDING = 2'b01, WAIT_ACK = 2'b10;  
    integer send_index;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            send_index <= 0;  
            window_status <= 0;  
            busy <= 0;  
            data_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    busy <= 0;  
                    if (send_enable) begin  
                        busy <= 1;  
                        data_out <= data_in;  
                        window_status[send_index] <= 1;  
                        send_index <= send_index + 1;  
                        state <= SENDING;  
                    end  
                end  
                SENDING: begin  
                    if (ack_received) begin  
                        window_status[send_index - 1] <= 0;  
                        state <= WAIT_ACK;  
                    end  
                end  
                WAIT_ACK: begin  
                    if (send_index < WINDOW_SIZE) begin  
                        busy <= 1;  
                        data_out <= data_in;  
                        window_status[send_index] <= 1;  
                        send_index <= send_index + 1;  
                        state <= SENDING;  
                    end else begin  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule