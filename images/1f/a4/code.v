module ethernet_mac_controller (  
    input wire clk,  
    input wire rst,  
    input wire start_tx,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg tx_done  
);  
    reg [2:0] state;  
    reg [2:0] next_state;  
    localparam IDLE = 3'b000,  
               TRANSMIT = 3'b001,  
               DONE = 3'b010;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  

    always @(*) begin  
        case (state)  
            IDLE: begin  
                tx_done = 0;  
                if (start_tx)  
                    next_state = TRANSMIT;  
                else  
                    next_state = IDLE;  
            end  
            TRANSMIT: begin  
                data_out = data_in;  
                next_state = DONE;  
            end  
            DONE: begin  
                tx_done = 1;  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule