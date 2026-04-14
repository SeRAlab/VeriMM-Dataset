module eth_mac_controller(  
    input clk,  
    input rst,  
    input start_receive,  
    input start_transmit,  
    output reg [1:0] state  
);  

    // State encoding  
    localparam IDLE = 2'b00;  
    localparam RECEIVE = 2'b01;  
    localparam TRANSMIT = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start_receive)  
                        state <= RECEIVE;  
                    else if (start_transmit)  
                        state <= TRANSMIT;  
                end  
                RECEIVE: begin  
                    if (start_transmit)  
                        state <= TRANSMIT;  
                    else  
                        state <= IDLE;  
                end  
                TRANSMIT: begin  
                    if (start_receive)  
                        state <= RECEIVE;  
                    else  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule