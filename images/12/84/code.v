module sliding_window_protocol #(parameter WINDOW_SIZE = 4, DATA_WIDTH = 8) (  
    input clk,  
    input rst,  
    input [DATA_WIDTH-1:0] data_in,  
    input ack_in,  
    output reg [DATA_WIDTH-1:0] data_out,  
    output reg send,  
    output reg ack_out  
);  
    reg [1:0] state;  
    reg [1:0] next_state;  
    reg [2:0] sent_count;  
    reg [2:0] ack_count;  
    
    localparam IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10, RECEIVED = 2'b11;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            sent_count <= 0;  
            ack_count <= 0;  
        end else begin  
            state <= next_state;  
        end  
    end  
    
    always @(*) begin  
        next_state = state;  
        send = 0;  
        ack_out = 0;  
        case (state)  
            IDLE: begin  
                if (sent_count < WINDOW_SIZE) begin  
                    next_state = SEND;  
                end  
            end  
            SEND: begin  
                send = 1;  
                data_out = data_in;  
                next_state = WAIT_ACK;  
            end  
            WAIT_ACK: begin  
                if (ack_in) begin  
                    ack_out = 1;  
                    ack_count = ack_count + 1;  
                    if (ack_count < WINDOW_SIZE) begin  
                        next_state = SEND;  
                    end else begin  
                        next_state = IDLE;  
                    end  
                end  
            end  
            RECEIVED: begin  
                if (ack_in) begin  
                    ack_out = 1;  
                end  
                next_state = IDLE;  
            end  
        endcase  
    end  
endmodule