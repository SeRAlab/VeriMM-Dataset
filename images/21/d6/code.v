module spi_controller(  
    input clk,  
    input cs,  
    input start,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg done  
);  
    reg [2:0] state;  
    reg [2:0] next_state;  
    reg [7:0] shift_reg;  
    reg [2:0] bit_count;  

    parameter IDLE = 3'b000,  
              SHIFT = 3'b001,  
              DONE = 3'b010;  

    always @(posedge clk or negedge cs) begin  
        if (!cs) begin  
            state <= IDLE;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(*) begin  
        case(state)  
            IDLE: begin  
                if (start) begin  
                    next_state = SHIFT;  
                    shift_reg = data_in;  
                    bit_count = 3'b111;  
                    done = 0;  
                end else begin  
                    next_state = IDLE;  
                    done = 1;  
                end  
            end  
            SHIFT: begin  
                if (bit_count > 0) begin  
                    data_out = shift_reg[bit_count];  
                    shift_reg = {shift_reg[6:0], 1'b0};  
                    bit_count = bit_count - 1;  
                    next_state = SHIFT;  
                    done = 0;  
                end else begin  
                    next_state = DONE;  
                    done = 1;  
                end  
            end  
            DONE: begin  
                next_state = IDLE;  
                done = 1;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule