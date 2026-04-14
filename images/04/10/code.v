module ARQ_System (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    input wire error,  
    output reg [7:0] data_out,  
    output reg ack,  
    output reg nack,  
    output reg [3:0] attempts  
);  
    reg [1:0] state;  
    localparam IDLE = 2'b00,  
               SEND = 2'b01,  
               ACK_RECEIVE = 2'b10;  
               
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            attempts <= 0;  
            ack <= 0;  
            nack <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (attempts < 10) begin  
                        data_out <= data_in;  
                        attempts <= attempts + 1;  
                        state <= SEND;  
                    end  
                end  
                SEND: begin  
                    if (error) begin  
                        nack <= 1;  
                        ack <= 0;  
                        state <= IDLE;  
                    end else begin  
                        ack <= 1;  
                        nack <= 0;  
                        state <= ACK_RECEIVE;  
                    end  
                end  
                ACK_RECEIVE: begin  
                    ack <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule