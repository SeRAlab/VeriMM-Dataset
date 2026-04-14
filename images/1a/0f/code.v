module turbo_encoder (  
    input clk,  
    input reset,  
    input data_in,  
    output reg [1:0] encoded_out  
);  
    reg [2:0] state;  
    reg [2:0] next_state;  

    // State encoding  
    localparam IDLE = 3'b000,  
               ENCODE = 3'b001;  

    // State transition  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  

    // Next state and output logic  
    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (data_in) begin  
                    encoded_out = 2'b11;  
                    next_state = ENCODE;  
                end else begin  
                    encoded_out = 2'b00;  
                    next_state = IDLE;  
                end  
            end  
            ENCODE: begin  
                encoded_out = {data_in, data_in};  
                next_state = IDLE;  
            end  
            default: begin  
                encoded_out = 2'b00;  
                next_state = IDLE;  
            end  
        endcase  
    end  
endmodule