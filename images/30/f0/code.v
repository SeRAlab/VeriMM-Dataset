module RLE_Encoder (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    output reg [7:0] bit_value_out,  
    output reg [3:0] count_out  
);  
    reg [7:0] current_value;  
    reg [3:0] count;  
    reg [1:0] state;  
    parameter IDLE = 2'b00, COUNT = 2'b01, OUTPUT = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            count <= 0;  
            current_value <= 0;  
            bit_value_out <= 0;  
            count_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    current_value <= data_in;  
                    count <= 1;  
                    state <= COUNT;  
                end  
                COUNT: begin  
                    if (data_in == current_value) begin  
                        count <= count + 1;  
                    end else begin  
                        bit_value_out <= current_value;  
                        count_out <= count;  
                        current_value <= data_in;  
                        count <= 1;  
                        state <= OUTPUT;  
                    end  
                end  
                OUTPUT: begin  
                    if (data_in == current_value) begin  
                        count <= count + 1;  
                    end else begin  
                        bit_value_out <= current_value;  
                        count_out <= count;  
                        current_value <= data_in;  
                        count <= 1;  
                    end  
                    state <= COUNT;  
                end  
            endcase  
        end  
    end  
endmodule