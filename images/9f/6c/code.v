module top_module(clk, rst, data_in, data_out);input clk, rst;
    input [31:0] data_in;
    output reg [31:0] data_out;
    
    parameter IDLE = 2'b00, LOAD = 2'b01, SHIFT = 2'b10;
    reg [1:0] state, next_state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 0;
        end
        else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    data_out <= 0;
                    if (data_in != 0) begin
                        next_state = LOAD;
                    end
                end
                LOAD: begin
                    data_out <= data_in;
                    next_state = SHIFT;
                end
                SHIFT: begin
                    data_out <= data_in << 1;
                    if (data_in == 0) begin
                        next_state = IDLE;
                    end
                    else begin
                        next_state = SHIFT;
                    end
                end
                default: begin
                    data_out <= 0;
                    next_state = IDLE;
                end
            endcase
        end
    end
endmodule