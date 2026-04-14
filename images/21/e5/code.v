module sd_card_controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00, INIT = 2'b01, READY = 2'b10;  
    reg [1:0] next_state;  
    reg [1:0] init_counter;  

    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            init_counter <= 2'b00;  
        end else begin  
            state <= next_state;  
        end  
    end  

    // Next state logic  
    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (start) begin  
                    next_state = INIT;  
                end else begin  
                    next_state = IDLE;  
                end  
            end  
            INIT: begin  
                if (init_counter < 2'b10) begin  
                    next_state = INIT;  
                    init_counter = init_counter + 1;  
                end else begin  
                    next_state = READY;  
                end  
            end  
            READY: begin  
                next_state = READY;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule