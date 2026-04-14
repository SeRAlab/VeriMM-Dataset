module uart_tx (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg tx,  
    output reg done  
);  
    reg [3:0] state;  
    reg [3:0] bit_count;  
    reg [10:0] shift_reg;  
    parameter IDLE = 4'd0, START = 4'd1, DATA = 4'd2, STOP = 4'd3;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            tx <= 1;  
            done <= 0;  
            bit_count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    done <= 0;  
                    if (start) begin  
                        shift_reg <= {1'b1, data_in, 1'b0}; // start bit + data + stop bit  
                        state <= START;  
                        bit_count <= 0;  
                    end  
                end  
                START: begin  
                    tx <= 0; // send start bit  
                    state <= DATA;  
                    bit_count <= 0;  
                end  
                DATA: begin  
                    if (bit_count < 8) begin  
                        tx <= shift_reg[bit_count];  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        state <= STOP;  
                    end  
                end  
                STOP: begin  
                    tx <= 1; // send stop bit  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule