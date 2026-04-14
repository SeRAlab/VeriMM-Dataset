module RLE_Encoder (  
    input wire clk,  
    input wire rst,  
    input wire valid_in,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg [3:0] count_out,  
    output reg done  
);  
    reg [7:0] current_value;  
    reg [3:0] count;  
    reg [3:0] state;  
    localparam IDLE = 0, COUNTING = 1, OUTPUT = 2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            done <= 0;  
            count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (valid_in) begin  
                        current_value <= data_in;  
                        count <= 1;  
                        state <= COUNTING;  
                    end  
                end  
                COUNTING: begin  
                    if (valid_in && data_in == current_value) begin  
                        count <= count + 1;  
                    end else begin  
                        data_out <= current_value;  
                        count_out <= count;  
                        state <= OUTPUT;  
                    end  
                end  
                OUTPUT: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule