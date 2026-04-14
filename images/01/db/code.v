module rle_encoder (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input data_valid,  
    output reg [7:0] count_out,  
    output reg [7:0] value_out,  
    output reg valid_out  
);  

    reg [7:0] current_value;  
    reg [3:0] count;  
    reg [2:0] state;  
    parameter IDLE = 3'b000, COUNT = 3'b001, OUTPUT = 3'b010;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            count <= 0;  
            valid_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (data_valid) begin  
                        current_value <= data_in;  
                        count <= 1;  
                        state <= COUNT;  
                    end  
                end  
                COUNT: begin  
                    if (data_valid && data_in == current_value) begin  
                        count <= count + 1;  
                    end else begin  
                        count_out <= count;  
                        value_out <= current_value;  
                        valid_out <= 1;  
                        state <= OUTPUT;  
                    end  
                end  
                OUTPUT: begin  
                    valid_out <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule